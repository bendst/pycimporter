import sys


def bar():
    #print("Hallo Welt")
    pass


def spam(a, b):
    print("1 ", a, "2 ", b)
    print(type(a), type(b))
    pass


class A(object):
    def __init__(self, a):
        self.a = a
        print(self.a)

    def setA(self, b):
        self.a = b

    def printA(self):
        print(self.a)


class B(object):

    def __init__(self):
        print(self)
        pass
