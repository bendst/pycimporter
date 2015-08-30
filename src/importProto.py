import importlib
import os
import sys
import inspect


def listAttr(obj):
    result = []
    if not isModul(obj):
        return result

    for i in dir(obj):
        result.append(i)
    return result


def isClass(obj):
    if obj is None:
        return False
    return inspect.isclass(obj)


def isMethod(obj):
    if obj is None:
        return False
    return inspect.isroutine(obj)


def isModul(obj):
    if obj is None:
        return False
    return inspect.ismodule(obj)


def loadModule(name):
    if not isinstance(name, str):
        return None

    try:
        return importlib.import_module(name)
    except:
        raise ImportError()


def callableMethod(obj, name):
    method = getattr(obj, name)
    if isMethod(method):
        return True

    return False


def getParameter(obj, name):
    method = getattr(obj, name)
    return inspect.getargspec(method).args


def hasParameter(obj, name):
    if getParameter(obj, name):
        return True
    return False


def callMethod(obj, name):
    method = getattr(obj, name)
    if isMethod(method):
        return method()
    return None


def callMethodargs(obj, name, *args):
    a = getParameter(obj, name)
    method = getattr(obj, name)
    if len(a) != len(args):
        return None
    if isMethod(method):
        return method(*args)

if __name__ == '__main__':
    s = input("modul name ")
    argu = ("Hi", 42)
    m = loadModule(s)
    la = listAttr(m)
    print(la)
    for i in la:
        if callableMethod(m, i):
            if hasParameter(m, i):
                callMethodargs(m, i, *argu)
            else:
                callMethod(m, i)
