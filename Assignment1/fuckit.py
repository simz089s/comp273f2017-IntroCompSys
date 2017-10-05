def q1():
    num = 0.32750702
    binum = []

    for mantissa in range(23):
        binum += [ str(num*2.0)[0] ]
        print("%.8f * 2 &= %.8f&\\textnormal{with integer part %s}\\\\" % (num, num*2.0, str(num*2.0)[0]))
        num *= 2.0
        if num > 1.0: num -= 1.0

    print(''.join(binum))

def q2():
    num = 0.00001 # 1.00001
    binum = []

    for mantissa in range(23):
        binum += [ str(num*2.0)[0] ]
        print("%.8f * 2 &= %.8f&\\textnormal{with integer part %s}\\\\" % (num, num*2.0, str(num*2.0)[0]))
        num *= 2.0
        if num > 1.0: num -= 1.0

    print(''.join(binum))

q1()
# q2()
