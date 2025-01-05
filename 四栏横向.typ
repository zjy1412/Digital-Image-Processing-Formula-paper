#set page(
  width: 29.7cm, // A4纸的高度作为宽度（横向）
  height: 21cm,  // A4纸的宽度作为高度（横向）
  margin: (top:0.5cm, bottom:0.5cm, left:0.5cm, right:0.5cm),
  columns: 4,     // 设置为4列
)

// #set block(spacing: 0.2em)  // 控制块级元素间距
// #set par(justify: true, leading: 0.2em)  // 控制段落行间距

//调整字体大小以适应四栏布局
#set text(0.6em) 

//伪粗体设置
#import "@preview/cuti:0.2.1": show-cn-fakebold
#show: show-cn-fakebold
#set text(font: ("Times New Roman", "SimSun"))

// 一级标题样式
#show heading.where(
  level: 1
): it => block(width: 100%)[
  #set align(center)
  #set text(7.5pt, weight: "bold")
  #it.body
]

// 二级标题样式
#show heading.where(
  level: 2
): it => block(width: 100%)[
  #set text(7pt, weight: "bold")
  #smallcaps(it.body)
]

// 三级标题样式
#show heading.where(
  level: 3
): it => block(width: 100%)[
  #set text(6.5pt, weight: "bold")
  #smallcaps(it.body)
]

// 包含所有章节
#include("ch2.typ")
#include("ch3.typ")
#include("ch4.typ")
#include("ch5.typ")
#include("ch6.typ")
#include("ch9.typ")
#include("ch10.typ")
#include("ch11.typ")