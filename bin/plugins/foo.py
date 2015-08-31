import sys
def bar():
    print("Hallo Welt")


def spam(a, b):
    print("1 ", a, "2 ", b)
    print(type(a), type(b))
    print(sys.getrefcount(__file__))


class A(object):
    def __init__(self, a):
        self.a = a
        print(self.a)
