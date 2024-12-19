
#import "@preview/mitex:0.2.4": *
#import "@preview/tablex:0.0.6": tablex, hlinex
#import "@preview/tablem:0.1.0": tablem

#heading[Chapter 10]

== 背景知识

差分: 前向 $frac(partial f (x), partial x) = f (x + 1) - f (x)$  后向 $frac(partial f (x), partial x) = f (x) - f (x - 1)$  中值 $frac(partial f (x), partial x) = frac(f (x + 1) - f (x - 1), 2)$  二阶 $frac(partial^2 f (x), partial x^2) = f (x + 1) - 2 f (x) + f (x - 1)$

(1)一阶导产生粗边缘；(2)二阶导对精细细节(如细线、孤立点和噪声)有更强的响应；(3)二阶导在灰度斜坡和台阶过渡处会产生双边缘响应；(4)二阶导的符号可用于确定边缘的过渡是从亮到暗(正)还是从暗到亮(负)。

== 孤立点检测

拉普拉斯  $nabla^2 f (x , y) = frac(partial^2 f, partial x^2) + frac(partial^2 f, partial y^2)  = f (x + 1 , y) + f (x - 1 , y) + f (x , y + 1) + f (x , y - 1) - 4 f (x , y)$

超过阈值T的标记 $g (x , y) = cases(delim: "{", 1  "," lr(|Z (x , y)|) > T, 0 "," upright("其他") & )$ $nabla^2 f=Z$

== 直线检测

#image("./img/zxjc.png",height: 5%)

== 边缘检测

梯度 $nabla f (x , y) equiv upright(g r a d) [f (x , y)] equiv mat(delim: "[", g_x (x , y); g_y (x , y)) = mat(delim: "[", frac(partial f (x , y), partial x); frac(partial f (x , y), partial y))$

欧几里得向量范数 $M (x , y) = ||nabla f (x , y)|| = sqrt(g_x^2 (x , y) + g_y^2 (x , y))$ 绝对值来近似梯度幅度：$ M (x , y) approx lr(|g_x|) + lr(|g_y|) $

梯度方向(垂直边缘) $alpha (x , y) = arctan [frac(g_y (x , y), g_x (x , y))]$

$ mat(
  z_1, z_2, z_3;
  z_4, z_5, z_6;
  z_7, z_8, z_9
) $

罗伯算子   $g_x = frac(partial f, partial x) = (z_9 - z_5)$     $g_y = frac(partial f, partial y) = (z_8 - z_6)$

Prewitt算子   $g_x = frac(partial f, partial x) = (z_7 + z_8 + z_9) - (z_1 + z_2 + z_3)$     $g_y = frac(partial f, partial y) = (z_3 + z_6 + z_9) - (z_1 + z_4 + z_7)$

Sobel 算子  $g_x = frac(partial f, partial x) = (z_7 + 2 z_8 + z_9) - (z_1 + 2 z_2 + z_3)$     $g_y = frac(partial f, partial y) = (z_3 + 2 z_6 + z_9) - (z_1 + 2 z_4 + z_7)$

二维高斯函数， $G (x , y) = upright(e)^(- frac(x^2 + y^2, 2 sigma^2))$

高斯拉普拉斯(LoG)函数:  $nabla^2 G (x , y) = (frac(x^2 + y^2 - 2 sigma^2, sigma^4)) upright(e)^(- frac(x^2 + y^2, 2 sigma^2))$

Marr-Hildreth算法  $g (x , y) = [nabla^2 G (x , y)] star.filled f (x , y) = nabla^2 [G (x , y) star.op f (x , y)]$  寻找g(x,y)的过零点来确定f(x,y)中边缘的位置

高斯差分(DoG)来近似式的LoG函数  $D_G (x , y) = frac(1, 2 pi sigma_1^2) upright(e)^(- frac(x^2 + y^2, 2 sigma_1^2)) - frac(1, 2 pi sigma_2^2) upright(e)^(- frac(x^2 + y^2, 2 sigma_2^2))$

// 坎尼 没有公式,跳过

== 连接边缘点

满足条件则连接 $mat(delim: "|", M (s , t) - M (x , y)) lt.eq E$ $mat(delim: "|", alpha (s , t) - alpha (x , y)) lt.eq A$

霍夫变换  $x cos theta + y sin theta = rho$

== 阈值处理

