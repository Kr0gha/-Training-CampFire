io.stdout:setvbuf('no')

--Empêche Love de filtrer les contours des images quand elles sont redimentionnées
--indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if  arg[#arg] == "-debug" then require("mobdebug").start() end



--///////
--Variables
--///////
WidthScreen = love.graphics.getWidth()
HeightScreen = love.graphics.getHeight()
NbrSilexMax = 9
NbrSilex= NbrSilexMax

--///////
--Table
--///////
GameWin = false
GameLoose = false


Barre = {}

Barre.Width = 300
Barre.Height = 20
Barre.X = WidthScreen/2 - Barre.Width/2
Barre.Y = HeightScreen/2 - Barre.Height/2 


Point = {}

Point.X = WidthScreen/2 - Barre.Width/2
Point.Width = 10
Point.Height = 20
Point.VitStart = 3
Point.Vit = 3


Target = {}
Target.BasseWidth = 60
Target.Width = Target.BasseWidth
Target.Height = 20
Target.X = Barre.X + Barre.Width /2 - Target.Width/2
Target.Y = Barre.Y
Target.Touch = false


Fire = {}
Fire.Update = 0



--///////
--Fonctions
--///////
function restartGame()
  Point.X = WidthScreen/2 - Barre.Width/2
  Point.Vit = Point.VitStart
  Fire.Update = 0
  GameWin = false
  GameLoose = false
  NbrSilex= NbrSilexMax
  Target.Width = Target.BasseWidth
  Target.X = Barre.X + Barre.Width /2 - Target.Width/2
  end

--///////
--Début
--///////
function love.load()

end

function love.update(dt)
--Impulsion de départ
Point.X = Point.X + Point.Vit 
--collision droite
if Point.X + Point.Width > Barre.Width + Barre.X then
    Point.Vit = Point.Vit * -1
    Point.X = Barre.X + Barre.Width - Point.Width
end
--collision gauche
if Point.X < Barre.X then
  Point.Vit = Point.Vit * -1
  Point.X = Barre.X
end

--collision avec l'interieur de la target
if Target.X < Point.X + Point.Width and Target.Width + Target.X > Point.X + Point.Width - Point.Width then
Target.Touch = true
    else
    Target.Touch = false
end
--Update de la variable Fire.Update
if Fire.Update == 3 then
  GameWin = true
end
-- Partie Gagne Perdu
if GameWin == true then
    Point.Vit = 0
end

if GameLoose == true then
    Point.Vit = 0
end

if NbrSilex <=0 and GameWin == false then
  GameLoose = true
end

end--fin function love.update



function love.draw()
  -- barre 
  love.graphics.setColor(0,1,0)
  love.graphics.rectangle("fill",Barre.X,Barre.Y,Barre.Width,Barre.Height)
  -- fin barre 
  --target
    if Target.Touch then
  love.graphics.setColor(0,0,1)
else
  love.graphics.setColor(1,1,1)
end
  love.graphics.rectangle("fill",Target.X,Target.Y,Target.Width,Target.Height)
   --fin target
   
  -- point 
  love.graphics.setColor(1,0,0)
  love.graphics.rectangle("fill",Point.X,HeightScreen/2 - Barre.Height/2 ,Point.Width,Point.Height)
  -- fin point
  
  --fire 
  if Fire.Update == 0 then 
    love.graphics.print("Rien",WidthScreen/2,HeightScreen/2 -50)
  end
  if Fire.Update == 1 then 
    love.graphics.print("Petite Braise",WidthScreen/2,HeightScreen/2 -50)
  end
    if Fire.Update == 2 then 
    love.graphics.print("Début de Flamme",WidthScreen/2,HeightScreen/2 -50)
  end
    if Fire.Update == 3 then 
    love.graphics.print("Flamme",WidthScreen/2,HeightScreen/2 -50)
    end
  -- fin fire 
  
  -- valeur des silex
  love.graphics.print("Nombre de silex restant: "..NbrSilex,WidthScreen/2,HeightScreen/2 + 25)
  -- fin valeur des silex
  
if GameWin == true then
  love.graphics.print("Bravo vous avez fait un feu et il vous reste "..NbrSilex.." silex",WidthScreen/2,150)
end
if GameLoose == true then
  love.graphics.print("Perdu Vous n'avez plus de silex pour votre feu",WidthScreen/2,150)
  end
  
end

function love.keypressed(key)
  
if GameWin == true and key == "r" or GameLoose == true and key == "r"then
  restartGame()
  end

if key == "space" and Target.Touch == true and Fire.Update < 3 and NbrSilex > 0 then
 print ("touchée")
 Fire.Update = Fire.Update + 1
 Point.Vit = Point.Vit + Point.Vit
 Target.Width = Target.Width -10
 Target.X = Barre.X + Barre.Width /2 - Target.Width/2
end

if key == "space" and Target.Touch == false and Fire.Update < 3 and NbrSilex > 0 then
  print ("fail")
  Fire.Update = 0
  Point.Vit = Point.VitStart
  NbrSilex = NbrSilex -1
  Target.Width = Target.BasseWidth
  end
end

--///////
--Fin
--///////