import importlib
import inspect
import sys
import os


cdef public void setEnv(char * pathToPlugins):
    """ Set the environment of the interpreter
    """
    st = pathToPlugins.decode("UTF-8")
    s = [os.getcwd() + '/' + st]
    sys.path = s


cdef public list listAttr(obj):
    """ List all attributes of a object
    """
    result = []
    if not isModul(obj):
        return result

    for i in dir(obj):
        result.append(i)
    return result


cdef public bint isClass(obj):
    """ Check whether given object is a class
    """
    if obj is None:
        return False
    return inspect.isclass(obj)


cdef public bint isMethod(obj):
    """ Check whether the object is a method or function
    """
    if obj is None:
        return False
    return inspect.isroutine(obj)


cdef public bint isModul(obj):
    """ Check whether the object is a modul
    """
    if obj is None:
        return False
    return inspect.ismodule(obj)


cdef public object newCls(module, char *nname, tuple args):
    """ initialize a new class of given module
    """
    name = nname.decode("UTF-8")
    obj = getattr(module, name)

    if isClass(obj):
        cl = obj(*args)
        return cl
    return None


cdef public object callClsMethod(object obj, char *nname, tuple args):
    """ Call a method from a initialize class
    """
    name = nname.decode("UTF-8")
    if not hasattr(obj, name):
        return None
    objM = getattr(obj, name)
    return objM(*args)


cdef public callMethodArgs(obj, char * nname, tuple args):
    """ Call a callable object attribute by which the object attribute is a method or function
    """
    name = nname.decode("UTF-8")
    a = getParameter(obj, nname)
    method = getattr(obj, name)

    if isMethod(method):
        return method(*args)


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
    """ Check whether given attribute of the object is callable
    """
    name = nname.decode("UTF-8")
    method = getattr(obj, name)

    if isMethod(method) or isClass(method):
        return True
    return False


cdef public list getParameter(obj, char * nname):
    """ get the parameter from the object attribute
    """
    name = nname.decode("UTF-8")
    method = getattr(obj, name)
    return inspect.getargspec(method).args


cdef public bint hasParameter(obj, nname):
    """ Check whether if the objects attribute has parameter
    """
    name = nname.decode("UTF-8")
    if getParameter(obj, name):
        return True
    return False
