#import "@preview/mitex:0.2.4": *

#heading[第二章：数字图像基础]

== 视觉感知要素

人视觉是由眼睛中锥状体和杆状体组成的。低照明级别杆状体起作用。在背景照明增强时锥状体起作用。


== 光和电磁波谱

$λ = c / ν$  $E = h v$
可见光的波长范围：约400\~700nm
$Delta I_epsilon.alt \/ I$ 称为韦伯比

辐射强度:光源流出能量总量;光通量给出观察者从光源感受到的能量，用流明数度量;亮度是光感受的主观描绘，不能测量，描述彩色感觉参数之一；灰度级用来描述单色光图像的亮度


== 图像感知与获取

传感器:CCD,CMOS

==== 简单的成像模型

$f(x,y)=i(x,y)r(x,y)$,其中$i(x,y)$为入射分量(低频)，$r(x,y)$为反射分量(高频)

其中$0 lt.eq f(x, y), i(x, y) < infinity$  $0 lt.eq r(x, y) lt.eq 1$ ;r=0全吸收,1全反射

== 图像取样和量化
对坐标值进行数字化称为取样,对幅度值进行数字化称为量化,原点位于图像的左上角，x 轴向下，y 轴向右

坐标索引：像二维坐标(𝑥, 𝑦);线性索引通过计算到坐标(0, 0)的偏移量得到的,行/列扫描

空间分辨率：图像中可辨别的最小细节 灰度分辨率：灰度级中可分辨的最小变化;打印机单位距离可以分辨的最小线对数DPI;数字图像:图像大小，即行数x列数PPI

图像对比度：一幅图像中最高和最低灰度级间的灰度差为对比度。

基本的图像重取样方法：图像内插。有最近邻内插;常选用双线性(v(x, y) = ax + by + cxy + d四个系数可用 4 个最近邻点的 4 个未知方程求出)和双三次内插。

== 像素间的一些基本关系

$N_4(p)$上下左右,$N_D (p)$四个对角,$N_8(p)=N_4(p) union N_D (p)$

值域V，V是0到255中的任一个子集

4邻接:点q在$N_4(p)$中，并q和p具有V中的数值

8邻接:点q在$N_8(p)$中，并q和p具有V中的数值

m邻接(混合邻接): 1.q在p的$N_4(p)$ 或者 2.q在p的$N_D(p)$中，$N_4(P) sect N_4(Q)$中没有V值的像素

欧氏距离(De): $D_e (p, q) = sqrt((x - s)^2 +(y - t)^2)$ 街区距离(D4): $D_4 (p, q) =|x - s| +|y - t|$

棋盘距离(D8): $D_8 (p, q) = max(|x - s|,|y - t|)$

== 对应元素运算和矩阵运算

图像相加：取平均降噪。相减：增强差别。相乘和相除：校正阴影。

三个基本量用于描绘彩色光源的质量：发光强度、光通量和亮度。

一幅数字图像占用的空间：$M times N times k$。