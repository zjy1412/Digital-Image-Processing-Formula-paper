
#import "@preview/mitex:0.2.4": *
#heading[Chapter 9]
//https://www.bilibili.com/video/BV1r28we5ERQ?spm_id_from=333.788.player.switch&vd_source=52b1b43b72a779e60509273373fde7d4
//p469


== 腐蚀和膨胀

B 对 A腐蚀 只用前景 $A minus.circle B = {z divides (B)_z subset.eq A} = {z divides (B)_z sect A^c = nothing} $


I为整个图，使用前景和背景运算 $I dot.circle B = {z divides (B)_z subset.eq A upright("和") A subset.eq I} union {A^c divides A^c subset.eq I} $

B对A膨胀 $hat(B)$是B旋转180° $A xor B = {z divides (hat(B))_z sect A eq.not diameter} = {z divides [(hat(B))_z sect A] subset.eq A} $

对偶性$  & (A minus.circle B)^c = A^c xor hat(B)\
\
 & (A xor B)^c = A^c minus.circle hat(B) $

== 开运算和闭运算

开运算先腐蚀再膨胀 $A circle.stroked.tiny B = (A minus.circle B) xor B =union.big {(B)_z divides (B)_z subset.eq A} $


闭运算先膨胀再腐蚀 $A bullet B = (A xor B) minus.circle B =[union.big {(B)_z divides (B)_z sect A = nothing}]^c $

对偶性$ (A circle.stroked.tiny B)^c & = (A^c bullet hat(B))\
\
(A bullet B)^c & = (A^c circle.stroked.tiny hat(B)) $

== 击中和击不中

结构元$B_1$检测前景，$B_2$检测背景

$ I ast.circle B_(1 , 2) = {z divides (B_1)_z subset.eq A upright(" 和 ") (B_2)_z subset.eq A^c} = (A dot.circle B_1) sect.big (A^c dot.circle B_2) $

== 基本算法

边界提取，前景-腐蚀结果$beta (A) = A - (A minus.circle B)$

孔洞填充,$I^c$为原图补集$X_k = (X_(k - 1) xor B) sect.big I^c , quad k = 1 , 2 , 3 , dots.h.c$

提取连通分量$X_k = (X_(k - 1) xor B) sect I , quad k = 1 , 2 , 3 , dots.h.c$

=== 凸包

$X_k^i = (X_(k - 1)^i times.circle B^i) union.big X_(k - 1)^i , quad i = 1 , 2 , 3 , 4 upright("和") k = 1 , 2 , 3 , dots.h.c$

使用第i个结构元程序收敛时(即当$X_k=X_(k 1)$时),令$D^i=X^i$凸包为$C (A) = union.big_(i = 1)^4 D^i$

假设${ B } = { B^1 , B^2 , B^3 , dots.h.c , B^n }$


=== 细化=原图-击中击不中

$A times.circle B = A - (A ast.circle B) = A sect.big (A ast.circle B)^c$ 另一公式$A times.circle { B } = ((dots.h.c ((A times.circle B^1) times.circle B^2) dots.h.c) times.circle B^n)$

=== 粗化=原图+击中击不中
$A dot.circle B = A union.big (A ast.circle B)$ 另一公式$A dot.circle { B } = ((dots.h.c ((A dot.circle B^1) dot.circle B^2) dots.h.c) dot.circle B^n)$

=== 骨架

对A的连续k次腐蚀$(A minus.circle k B) = ((dots.h.c (A minus.circle B) minus.circle B) minus.circle dots.h.c) minus.circle B \)$

K是A被腐蚀为一个空集之前的最后一个迭代步骤$K = max {k divides (A minus.circle k B) eq.not nothing}$


$S (A) = union.big_(k = 0)^K S_k (A) S_k (A) = (A minus.circle k B) - (A minus.circle k B) circle.stroked.tiny B$


=== 裁剪

//没看懂,等PPT

使用一系列设计用来检测端点的结构元对集合进行细化处理$X_1 = A times.circle { B }$

删除寄生分支$X_2 = union.big_(k = 1)^8 (X_1 ast.circle B^k)$

H是元素值为1的一个3×3结构元$X_3 = (X_2 xor H) sect A$

$X_4 = X_1 union X_3$



== 形态学重建
https://www.bilibili.com/video/BV14q8weHExH?spm_id_from=333.788.player.switch&vd_source=52b1b43b72a779e60509273373fde7d4