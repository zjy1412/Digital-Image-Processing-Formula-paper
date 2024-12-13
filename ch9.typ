
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
