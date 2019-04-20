import Foundation 

print("Hello World")

func evn_or_odd(a: Int) -> String {
    if(a%2 == 0){return "Even"}

    else {return "Odd"}
}

let number2 = 7
var number3 = 0


print(4,"=",evn_or_odd(a:4))
print(7,"=",evn_or_odd(a:7))
print(0,"=",evn_or_odd(a:0))
print(167465*3, "=", evn_or_odd(a:167465*3))

print(5+5-3*2/4)
//Follows PEMDAS, 3*2=6/4=1 5+5=10-1 =9
