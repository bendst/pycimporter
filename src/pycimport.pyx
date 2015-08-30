import importlib
import inspect
import sys
import os


cdef public void setEnv(char *pathToPlugins):
    st = pathToPlugins.decode("UTF-8")
    s = [os.getcwd()+'/'+st]

    sys.path = s

cdef public list listAttr(obj):
    result = []
    if not isModul(obj):
        return result

    for i in dir(obj):
        result.append(i)
    return result

cdef public bint isClass(obj):
    if obj is None:
        return False
    return inspect.isclass(obj)


cdef public bint isMethod(obj):
    if obj is None:
        return False
    return inspect.isroutine(obj)

cdef public bint isModul(obj):
    if obj is None:
        return False
    return inspect.ismodule(obj)

cdef public loadModule(char *nname):
    """ Load a python modul from current directory
    """
    name = nname.decode("UTF-8")
    if not isinstance(name, str):
        return None

    try:
        return importlib.import_module(name)
    except:
        raise Exception(name+"could not be loaded")

cdef public bint callableMethod(obj,char *nname):
    name = nname.decode("UTF-8")
    method = getattr(obj, name)
    if isMethod(method):
        return True
    return False

cdef public getParameter(obj, char *nname):
    name = nname.decode("UTF-8")
    method = getattr(obj, name)
    return inspect.getargspec(method).args

cdef public bint hasParameter(obj, nname):
    name = nname.decode("UTF-8")
    if getParameter(obj, name):
        return True
    return False

cdef public callMethod(obj, char *nname):
    name = nname.decode("UTF-8")
    method = getattr(obj, name)
    if isMethod(method):
        return method()
    return None

cdef public callMethodArgs(obj, char* nname, tuple args):
    name = nname.decode("UTF-8")
    a = getParameter(obj, name)
    method = getattr(obj, name)
    if len(a) != len(args):
        return None
    if isMethod(method):
        return method(*args)
