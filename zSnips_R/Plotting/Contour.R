# IN THIS SCRIPT:
# basic contour plot
# filled contour plot
# 3D plot


#----------------------------------------------------------
# BASIC EXAMPLES

x=seq(-pi,pi,length=50)

y=x
f=outer(x,y,function (x,y)cos(y)/(1+x^2))
contour(x,y,f)

contour(x,y,f,nlevels=45, add=T)

fa=(f-t(f))/2
contour (x,y,fa,nlevels=15)




#----------------------------------------------------------
# FILLED CONTOUR PLOT
par(mfrow = c(1,1))
filled.contour(volcano, 
               color=terrain.colors, 
               asp=1,
               plot.axes = contour(volcano, 
                                   add=T)
              )
                

      
#----------------------------------------------------------
# 3D CONTOUR PLOT
# these are like contour plots but with color

x = seq(-pi,pi,length=50) # create sequence
y = x                     # create y
f=outer(x,                # create function for f
        y,
        function (x,y) cos(y)/(1+x^2))

fa=(f-t(f))/2             # create fa value (z dimension value)
        
persp(x,y,fa)   # create 3D map
persp(x,y,fa,theta=30)   # rotated 30 degrees
persp(x,y,fa,theta=30, phi=20)   # tilted down 20 degrees
persp(x,y,fa,theta=30, phi=40)   # tilted down 40 degrees

        
# EXAMPLE         
persp(volcano, 
      theta=25, phi=30, expand=0.5, 
      col="lightblue")       
