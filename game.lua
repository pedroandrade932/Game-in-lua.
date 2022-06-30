-- title:  Aliens Shooter
-- author: Pedro G. H. Andrade.
-- desc:   Shooting game (v0.2)
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.2
-- script: lua

-- game table

game={
 tela=0,
 points=0,
 pos_x=240,
	pos_y=136,
	timer=0,
	tics=0,
	menu=true,
	timeinc=function(self)
	 if self.tics==59 then
		 self.timer=self.timer+1
		 self.tics=0
		else
		 self.tics=self.tics+1
		end
	end,
	
	
	show_points=function(self)
	 local points=tostring(self.points)
		local size=string.len(points)
		for i=4-size,1,-1 do
		 points="0"..points
		end
	 return points
end,

btn_menu=function()
	 if btn(6) then
		 game.menu=false
	end
	end,
	
btn_ins=function()
	 if btn(7) then
		 game.tela=1
	end
	end,
	

	
	spawn_alien=function(nx,ny,nsprite)
	 return {
		x=nx,
		y=ny,
		alive=true,
		sprite=nsprite
		} 
	end,
	
	spawn_bullet=function(nx,ny,nsprite,iss)
 return{
	x=nx,
	y=ny,
 on_screen	=true,
	sprite=nsprite,
	issuer=iss
	}
end,
		
 init=function(self,sp,al,br)
	local min=1
	local max=#sprites.alien
	for h=1,6 do
  for i=1,6 do
  table.insert(al,self.spawn_alien(
    self.pos_x//8*(i+0.3),
				h*10,
			 sp.alien[math.random(min,max)]	
	  )
	 )
  end
 end	
end

}

-- invalid color

cls_color={

cls_c=0

}

-- spr table

sprites={

pt=0,
ship=256,
anima_s=2,
alien={260,262,264,266},
bullet=288,
alien_bullet=289,
life=290

}

-- tiles table

tiles={

bricks={2,3,4,5,6,7,23}

}

-- enemys tables

aliens={

dir_flip=1,
atack_speed=1024,
hor_dir=7,
flips=2,
draw=function(self)
 for i,a in ipairs(self) do
	 if a.alive then
  spr(a.sprite,a.x,a.y,cls_color.cls_c,1,0,0,1,1)
  end
 end
end,

remove_dead=function(self)
	for i,a in ipairs(self) do
	 if not a.alive then
		 table.remove(self,i)
		end
	end 
end,

 move=function(self)
	 if 
		 game.tics==0 and
		 game.timer%1==0
	 then
		 if self.hor_dir==0 then
			 self.dir_flip=self.dir_flip*-1
				self.hor_dir=13
				self.flips=self.flips-1
			end
		if self.flips==0 then
		 self.flips=2
			for i,a in ipairs(self) do
	   a.y=a.y+6
			end
		else
	 	for i,a in ipairs(self) do
	   a.x=a.x+6*self.dir_flip
			end
			self.hor_dir=self.hor_dir-1
	 end
	end	
end,
	
 shoot=function(self,sp)
	 for i,a in ipairs(self) do
		 if math.random
			(self.atack_speed
		 )==self.atack_speed
			and ship.lives >= 2 
			then
			sfx(0,22,10)
			table.insert(
		 bullets,
			game.spawn_bullet(
			a.x,
			a.y,
			sp,
			"aliens"
	 	)
		)
			end
		end
end
	
}

-- "tank" table

ship={

 x=game.pos_x//2,
 y=game.pos_y//1.2+7,
	lives=5,
	
 move=function(self)
	if
	 btn(2) and self.x>0
	then self.x=self.x-1 end
	if
	 btn(3) and self.x+16<game.pos_x
	then self.x=self.x+1 end
end,

draw=function(self)
 spr(sprites.ship+sprites.pt%(30*sprites.anima_s)//30*2,self.x,self.y,cls_color.cls_c,1,0,0,2,2)
end,
draw_life=function(self,sprite)
 spr(sprites.life,0,0,0,1,0,0,6,1)
	end,

 shoot=function(self,sp)
	 if btnp(4,20,30) and 
		ship.lives >= 2 and
		#aliens > 0 then
		sfx(0,32,10)
  table.insert(
		 bullets,
			game.spawn_bullet(
			self.x,
			self.y,
			sp,
			"player"
	 ) 
	)
	 
	end
end,
	

}

-- bullets table

bullets={
draw=function(self)
 for i,b in ipairs(self) do
	 if b.on_screen then
  spr(b.sprite,b.x+4,b.y,cls_color.cls_c)
  end
 end
end,

move=function(self)
 for i,b in ipairs(self)do
	 if b.issuer=="player" then
	  b.y=b.y-2
		else
		 b.y=b.y+2
		end
	end
end,

flag_oos=function(self)
  for i,b in ipairs(self) do
	 if b.y<=-8 then
		 b.on_screen=false
		end
	end 
end,

remove_oos=function(self)
 for i,b in ipairs(self) do
	 if not b.on_screen then
		 table.remove(self,i)
		end
	end 
end,

hit_bricks=function(self)
 for i,b in ipairs(self) do
 if b.y>0 and b.on_screen then 
  curr_tile=mget((b.x+8)//8,
		(b.y+1)//8)
	 for i=0,6 do
	 if
	  curr_tile==tiles.bricks[i]
	 then
		  mset((b.x+8)//8,(b.y+1)//8,
			 tiles.bricks[i+2])
	   b.on_screen=false
		  self:remove_oos()
				end
		 end
		end
	end
end,

 hit_ship=function(self)
	 local missed=true
	 for i,b in ipairs(self) do
		  missed=not(
			  b.x<ship.x+16 and
					b.x+16>ship.x	and
					b.y<ship.y+8 and
					b.y+8>ship.y and
					b.issuer=="aliens"
				)
			if not missed and ship.lives >= 2 then
			ship.lives = ship.lives - 1
			table.remove(self,i)
			mset(ship.lives,0,23)
			sfx(1,20,10)
		 end
		end
	end,
 
	hit_target=function(self)
	 for i,b in ipairs(self) do
		 for j,a in ipairs(aliens) do
		  a.alive=not(
			  b.x<a.x+4 and
					b.x+10>a.x	and
					b.y<a.y+8 and
					b.y+8>a.y and
					b.issuer=="player"
				)
				b.on_screen=a.alive
				if not a.alive then
				 game.points=game.points+28
					aliens.atack_speed=aliens.atack_speed-28
				 table.remove(self,i)
					table.remove(aliens,j)
				end
		 end
		end
	end
}

menu={

draw=function(self,msg)
 local game_over=msg
	local width=print(game_over,0,-12,12,
	false,2)
	print
	(game_over,(240-width)//2,
	(136-6)//2,12,false,2)
	local play_again="Press B(X) to restart"
 width=print(play_again,0,-6,9)
	print(play_again,(240-width)//2,
	(136-6)//1,0)
end,

draw_1=function(self,msg)
 local game_over=msg
	local width=print(game_over,0,-12,12,
	false,2)
	print
	(game_over,(240-width)//2,
	(136-6)//2,14,false,2)
end,

 restart_game=function(self)
  if btn(5) then reset() end
 end
}

-- general functions

mic1=false-- title music. (Track 0)
mic2=false-- Gameover music. (Track 3)
mic3=false-- 1 music. (Track 1)
mic4=false-- Victory music. (Track 2)
game:init(sprites,aliens,bricks)

function TIC()
	cls()
	if	ship.lives >= 2 then
		map(0,0,240,136,0,0)
	 print("Score: "..game:show_points(),
		174,1,10,true)
		ship:draw_life()
		print("lifes",
		9.5,1,12,true,1)
		if game.menu==true and
		 game.tela==0 then
			if mic1 == false then
				music(0,-1,-1,true)
				mic1=true
			end
	  print("Aliens shooter",
			38,50,7,true,2)
			print("Press X(A)to start or ",
			60,110,12,true,1)
			print("press Y(S)to instructions",
			50,117,12,true,1)
			print("Created by Pedro G. H. Andrade.",
			60,129,0,true,1,1)
			game.btn_menu()
			game.btn_ins()
		end
	end
	if game.tela==1 then
		print("instructions:",
		80,10,12,true,1)
		print("keys left and right = move the tank",
		10,30,12,true,1)
		print("key A(Z on the pc) = shoot a bullet",
		10,40,12,true,1)
		print("Press B(X)to back",
		67,130,0,true,1)
		menu:restart_game()
	end
	if game.menu==false and game.tela==0 then
			if mic3 == false then
				music(1,-1,-1,true)
				mic3=true
			end
		game:timeinc()
	 ship:shoot(sprites.bullet)
		bullets:flag_oos()	
		bullets:remove_oos()
		bullets:draw()
		bullets:move()
		bullets:hit_bricks()
		bullets:hit_target()
		bullets:hit_ship()
		ship:move()
		ship:draw(sprites.ship)
		aliens:shoot(sprites.alien_bullet)
		aliens:move()
		aliens:draw()
		aliens:remove_dead()
		if #aliens==0 then
			if mic4 == false then
				music(2,-1,-1,false)
				mic4=true
			end
			map(0,0,240,136,0,0)		
		 menu:draw("Victory!")
			print("Score: "..game:show_points(),174,1,10,true)
			ship:draw_life()
			print("lifes",9.5,1,12,true,1)
			menu:restart_game()
		end
		if ship.lives <= 1 then
			if mic2 == false then
				music(3,-1,-1,false)
				mic2=true
			end
			map(0,0,240,136,0,0)
			menu:draw("Game Over")
			print("Score: "..game:show_points(),174,1,10,true)
			ship:draw_life()
			print("lifes",9.5,1,12,true,1)
			menu:restart_game()
		end
	end
	sprites.pt = sprites.pt+1
	
end