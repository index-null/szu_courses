.orig x3000
;2022190025郭昌华，实现了一个简易的用户登陆验证功能
;装载输入内容的储存地址
ld r1,InputAddress
;输出账户输入提示
lea r0,prompt1
puts

;循环逐个字符输入账号，储存在0x3500中，并回显
SaveAccountLoop getc
out
str r0,r1,#0
add r1,r1,#1
add r0,r0,#-10
brnp SaveAccountLoop
add r1,r1,#-1
str r0,r1,#0


;输出密码输入提示
add r1,r1,#1
lea r0,prompt2
puts

;循环逐个字符输入密码，加密储存在账号之后，用0x0分隔，并回显
SavePasswordLoop getc
out
;加密储存
add r0,r0,#-12
str r0,r1,#0
add r1,r1,#1
add r0,r0,#2
brnp SavePasswordLoop
add r1,r1,#-1
str r0,r1,#0

;装载初始的用户信息数据
ld r2,UserAddress

add r2,r2,#-1
;开始账户验证的循环
Recompare add r2,r2,#1
ld r1,InputAddress

ldr r6,r2,#0
brz FailLogin;如果所有预存的账户均尝试失败，则跳转到“失败”
;初始化计数器，记录完成比较的两部分（账户、密码）
and r5,r5,#0
add r5,r5,#2

;逐位比较当前字符是否相等
LoopCheck ldr r3,r6,#0
ldr r4,r1,#0



not r4,r4
add r4,r4,#1
add r3,r4,r3
;当前比较账户不匹配，继续比较下一个
brnp Recompare
add r4,r4,#0
brnp NotX0;当前相等的位为0x0，计数器减1
add r5,r5,#-1
NotX0 add r1,r1,#1
add r6,r6,#1
add r5,r5,#0;计数器为0，说明账户，密码均匹配，跳转到“成功”
brz SuccessLogin
;继续比较下一位
br LoopCheck


;成功登陆的提示信息输出，需要打印账户名称，再输出提示信息
SuccessLogin ldr r6,r2,#0
Printname ldr r0,r6,#0
brz Outprompt
out
add r6,r6,#1
br Printname
Outprompt lea r0,prompt3
puts
br TheEnd

;登陆失败，只需要打印一句提示信息
FailLogin lea r0,prompt4
puts
br TheEnd

;数据储存部分
prompt1 .stringz "Login ID:"
InputAddress .fill x3500
UserAddress .FILL x4000
prompt2 .stringz "Password:"
prompt3 .stringz ", you have successfully logged in. "
prompt4 .stringz "Invalid UserID/Password. Your login failed. "

TheEnd halt
.end