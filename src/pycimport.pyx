import importlib
import inspect
import sys
import os


cdef public void setEnv(char * pathToPlugins):
    st = pathToPlugins.decode("UTF-8")
    s = [os.getcwd() + '/' + st]
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

cdef public object newClass(module, char *nname, tuple args):
    name = nname.decode("UTF-8")
    obj = getattr(module, name)

    if isClass(obj):
        cl = obj(*args)
        return cl
    return None


cdef public object callObjMethod(object obj, char *nname, tuple args):
    name = nname.decode("UTF-8")
    if not hasattr(obj, name):
        return None
    objM = getattr(obj, name)
    objM(*args)

cdef public loadModule(char * nname):
    """ Load a python modul from current directory
    """
    name = nname.decode("UTF-8")
    if not isinstance(name, str):
        return None

    try:
        return importlib.import_module(name)
    except:
        raise Exception(name + "could not be loaded")


cdef public bint isCallableObject(obj, char * nname):
    name = nname.decode("UTF-8")
    method = getattr(obj, name)

    if isMethod(method) or isClass(method):
        return True
    return False


cdef public list getParameter(obj, char * nname):
    name = nname.decode("UTF-8")
    method = getattr(obj, name)
    return inspect.getargspec(method).args


cdef public bint hasParameter(obj, nname):
    name = nname.decode("UTF-8")
    if getParameter(obj, name):
        return True
    return False


cdef public callObject(obj, char * nname):
    name = nname.decode("UTF-8")
    method = getattr(obj, name)

    if isClass(obj) and isMethod(method):
        return obj.method()
    if isMethod(method):
        return method()
    if isClass(method):
        cl = method.__init__(method)
        return cl
    return None


cdef public callObjectArgs(obj, char * nname, tuple args):
    name = nname.decode("UTF-8")
    a = getParameter(obj, nname)
    method = getattr(obj, name)
    if isClass(obj) and isMethod(method):
        return obj.method( args)
    if isMethod(method):
        return method(*args)
    if isClass(method):
        cl = method.__init__(method, *args)
        return cl
