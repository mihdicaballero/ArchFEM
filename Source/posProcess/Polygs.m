function [ x, y ] = Polygs ( P , offset , NSides , fase )


t = linspace ( 0, 2*pi , NSides + 1 ) ;
x = P(1) + offset * cos ( t + fase ) ;
y = P(2) + offset * sin ( t + fase ) ;

