=======================
Python 基础小抄
=======================

Python 命名规范
--------------------

.. code-block:: python

    # 见: PEP 8

    # 类 （class）
    #
    # 推荐:
    #   MyClass
    # 不推荐:
    #   myClass, my_class
    MyClass

    # 方法 （func）, 模块 （module）, 包 （package）, 变量 （variables）
    #
    # 推荐:
    #   var_underscore_separate
    # 不推荐:
    #   varCamel, VarCamel
    var_underscore_separate

    # 公有变量
    var

    # 内部变量
    _var

    # 避免和关键字冲突
    var_

    # 类的私有变量
    __var

    # 类的保护变量
    _var_

    # "magic" 方法或属性
    # 例: __init__, __file__, __main__
    __var__

    # 内部一次性变量
    # 通常在循环中使用
    # 例: [_ for _ in range(10)]
    # 根本不用的变量（占位符）
    # for _, a in [(1,2),(3,4)]: print a
    _


使用 ``__future__`` 向后移植（backport） 特性
---------------------------------------------

.. code-block:: python

    # PEP 236 - Back to the __future__

    # 在 python2 中使用 python3 的 print 方法

    >>> print "Hello World"  # print 是一个语句（statement）
    Hello World
    >>> from __future__ import print_function
    >>> print "Hello World"
      File "<stdin>", line 1
        print "Hello World"
                          ^
    SyntaxError: invalid syntax
    >>> print("Hello World") # print 是方法
    Hello World

    # python2 中使用 python3 的 unicode_literals

    >>> type("Guido") # python 3 中string 类型是 str
    <type 'str'>
    >>> from __future__ import unicode_literals
    >>> type("Guido") # string 类型变成 unicode
    <type 'unicode'>

    # backport PEP 238 -- 除法操作修改

    >>> 1/2
    0
    >>> from __future__ import division
    >>> 1/2   # 返回浮点数 (正常人理解的除法)
    0.5
    >>> 1//2  # 返回一个整型 (floor 除法)
    0


.. note::

    ``from __future__ import feature`` 是一个 `future 语句`__。
    和一般的 ``import`` 不同，它用于在当前版本的 python 版本中引入之后版本的新特性

.. _future: https://docs.python.org/2/reference/simple_stmts.html#future
__ future_


查看对象属性
------------

.. code-block:: python

    # 查看列表属性
    >>> dir(list)
    ['__add__', '__class__', ...]

定义 ``__doc__`` 方法
------------------------------

.. code-block:: python

    # 定义函数说明
    >>> def Example():
    ...   """ This is an example function """
    ...   print "Example function"
    ...
    >>> Example.__doc__
    ' This is an example function '

    # 使用 help 方法
    >>> help(Example)

检查实例类型
------------

.. code-block:: python

    >>> ex = 10
    >>> isinstance(ex,int)
    True

检查、获取、赋值属性
-------------------------

.. code-block:: python

    >>> class Example(object):
    ...   def __init__(self):
    ...     self.name = "ex"
    ...   def printex(self):
    ...     print "This is an example"
    ...

    # 检查对象是否有某种属性
    # hasattr(obj, 'attr')
    >>> ex = Example()
    >>> hasattr(ex,"name")
    True
    >>> hasattr(ex,"printex")
    True
    >>> hasattr(ex,"print")
    False

    # 获取对象属性
    # getattr(obj, 'attr')
    >>> getattr(ex,'name')
    'ex'

    # 给对象某种属性赋值
    # setattr(obj, 'attr', value)
    >>> setattr(ex,'name','example')
    >>> ex.name
    'example'

继承检查
--------

.. code-block:: python

    >>> class Example(object):
    ...   def __init__(self):
    ...     self.name = "ex"
    ...   def printex(self):
    ...     print "This is an Example"
    ...
    >>> issubclass(Example, object)
    True

查询所有 global 变量
--------------------

.. code-block:: python

    # globals() 返回一个字典
    # {'variable name': variable value}
    >>> globals()
    {'args': (1, 2, 3, 4, 5), ...}

检查 **callable**
-------------------

.. code-block:: python

    >>> a = 10
    >>> def fun():
    ...   print "I am callable"
    ...
    >>> callable(a)
    False
    >>> callable(fun)
    True

获取方法名、类名
-----------------

.. code-block:: python

    >>> class ExampleClass(object):
    ...   pass
    ...
    >>> def example_function():
    ...   pass
    ...
    >>> ex = ExampleClass()
    >>> ex.__class__.__name__
    'ExampleClass'
    >>> example_function.__name__
    'example_function'


``__new__`` & ``__init__``
--------------------------

.. code-block:: python

    # __init__ 会被调用
    >>> class ClassA(object):
    ...     def __new__(cls, arg):
    ...         print '__new__ ' + arg
    ...         return object.__new__(cls, arg)
    ...     def __init__(self, arg):
    ...         print '__init__ ' + arg
    ...
    >>> o = ClassA("Hello")
    __new__ Hello
    __init__ Hello

    # __init__ 不会被调用
    >>> class ClassB(object):
    ...     def __new__(cls, arg):
    ...         print '__new__ ' + arg
    ...         return object
    ...     def __init__(self, arg):
    ...         print '__init__ ' + arg
    ...
    >>> o = ClassB("Hello")
    __new__ Hello


菱形继承问题
--------------------

.. code-block:: python

    # 多继承 MRO（Method Resolution Order）：方法解析顺序
    # 采用 C3 算法

    >>> def foo_a(self):
    ...     print("This is ClsA")
    ...
    >>> def foo_b(self):
    ...     print("This is ClsB")
    ...
    >>> def foo_c(self):
    ...     print("This is ClsC")
    ...
    >>> class Type(type):
    ...     def __repr__(cls):
    ...         return cls.__name__
    ...
    >>> ClsA = Type("ClsA", (object,), {'foo': foo_a})
    >>> ClsB = Type("ClsB", (ClsA,), {'foo': foo_b})
    >>> ClsC = Type("ClsC", (ClsA,), {'foo': foo_c})
    >>> ClsD = Type("ClsD", (ClsB, ClsC), {})
    >>> ClsD.mro()
    [ClsD, ClsB, ClsC, ClsA, <type 'object'>]
    >>> ClsD().foo()
    This is ClsB


类呈现方法
-----------

.. code-block:: python

    >>> class Example(object):
    ...    def __str__(self):
    ...       return "Example __str__"
    ...    def __repr__(self):
    ...       return "Example __repr__"
    ...
    >>> print str(Example())
    Example __str__
    >>> Example()
    Example __repr__

长字符串分割
------------

.. code-block:: python

    # 长字符串
    >>> s = 'This is a very very very long python string'
    >>> s
    'This is a very very very long python string'

    # 使用反斜杠
    >>> s = "This is a very very very " \
    ...     "long python string"
    >>> s
    'This is a very very very long python string'

    # 使用括号
    >>> s = ("This is a very very very "
    ...      "long python string")
    >>> s
    'This is a very very very long python string'

    # 使用 '+'
    >>> s = ("This is a very very very " +
    ...      "long python string")
    >>> s
    'This is a very very very long python string'

    # 使用三引号加反斜杠
    >>> s = '''This is a very very very \
    ... long python string'''
    >>> s
    'This is a very very very long python string'

**优雅地** 获取列表元素
------------------------

.. code-block:: python

    >>> a = [1, 2, 3, 4, 5]
    >>> a[0]
    1
    >>> a[-1]
    5
    >>> a[0:]
    [1, 2, 3, 4, 5]
    >>> a[:-1]
    [1, 2, 3, 4]

    # a[start:end:step]
    >>> a[0:-1:2]
    [1, 3]

    # 使用 slice 对象
    # slice(start,end,step)
    >>> s = slice(0, -1, 2)
    >>> a[s]
    [1, 3]

    # 获取循环中索引和对象
    >>> a = range(3)
    >>> for idx, item in enumerate(a):
    ...   print (idx,item),
    ...
    (0, 0) (1, 1) (2, 2)

    # 将两个队列转换成元组队列
    >>> a = [1, 2, 3, 4, 5]
    >>> b = [2, 4, 5, 6, 8]
    >>> zip(a, b)
    [(1, 2), (2, 4), (3, 5), (4, 6), (5, 8)]

    # 过滤器
    >>> [x for x in range(5) if x > 1]
    [2, 3, 4]
    >>> l = ['1', '2', 3, 'Hello', 4]
    >>> predicate = lambda x: isinstance(x, int)
    >>> filter(predicate, l)
    [3, 4]

    # 列表去重
    >>> a = [1, 2, 3, 3, 3]
    >>> list({_ for _ in a})
    [1, 2, 3]
    # 或者
    >>> list(set(a))
    [1, 2, 3]

    # 列表翻转
    >>> a = [1, 2, 3, 4, 5]
    >>> a[::-1]
    [5, 4, 3, 2, 1]

**优雅地** 获取字典元素
------------------------

.. code-block:: python

    # 获取字典所有的键值
    >>> a = {"1":1, "2":2, "3":3}
    >>> b = {"2":2, "3":3, "4":4}
    >>> a.keys()
    ['1', '3', '2']

    # 元组方式获取字典键值对
    >>> a.items()
    [('1', 1), ('3', 3), ('2', 2)]

    # 获取两个字典相同的键
    >>> [_ for _ in a.keys() if _ in b.keys()]
    ['3', '2']
    # 更优雅的方式
    >>> c = set(a).intersection(set(b))
    >>> list(c)
    ['3', '2']
    # 或者
    >>> [_ for _ in a if _ in b]
    ['3', '2']

    # 更新字典
    >>> a.update(b)
    >>> a
    {'1': 1, '3': 3, '2': 2, '4': 4}

**优雅地** 给列表、字典赋值
----------------------------

.. code-block:: python

    # 初始化列表
    >>> ex = [0] * 10
    >>> ex
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    # 合并列表
    >>> a = [1, 2, 3]; b = ['a', 'b']
    >>> a + b
    [1, 2, 3, 'a', 'b']

    # 列表推导式
    >>> [x for x in range(10)]
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    >>> fn = lambda x: x**2
    >>> [fn(x) for x in range(5)]
    [0, 1, 4, 9, 16]
    >>> {'{0}'.format(x): x for x in range(3)}
    {'1': 1, '0': 0, '2': 2}

    # 使用内建函数“map”
    >>> map(fn, range(5))
    [0, 1, 4, 9, 16]

命名元组（NamedTuple）
----------------------

.. code-block:: python

    # namedtuple(typename, field_names)
    # 定义没有方法的类
    >>> from collections import namedtuple
    >>> Example = namedtuple("Example",'a b c')
    >>> e = Example(1, 2, 3)
    >>> print e.a, e[1], e[1] + e.b
    1 2 4

``__iter__`` - 代理迭代器
-------------------------

.. code-block:: python

    # __iter__ 返回一个迭代器对象
    # 注意: 列表是一个 “可迭代” 对象，不是一个迭代器
    >>> class Example(object):
    ...    def __init__(self,list_):
    ...       self._list = list_
    ...    def __iter__(self):
    ...      return iter(self._list)
    ...
    >>> ex = Example([1, 2, 3, 4, 5])
    >>> for _ in ex: print _,
    ...
    1 2 3 4 5

像迭代器一样使用生成器
----------------------

.. code-block:: python

    # 见: PEP289
    >>> a = (_ for _ in range(10))
    >>> for _ in a: print _,
    ...
    0 1 2 3 4 5 6 7 8 9

    # 等价于
    >>> def generator():
    ...   for _ in range(10):
    ...     yield _
    ...
    >>> for _ in generator(): print _,
    ...
    0 1 2 3 4 5 6 7 8 9

仿写列表
--------

.. code-block:: python

    >>> class EmuList(object):
    ...   def __init__(self, list_):
    ...     self._list = list_
    ...   def __repr__(self):
    ...     return "EmuList: " + repr(self._list)
    ...   def append(self, item):
    ...     self._list.append(item)
    ...   def remove(self, item):
    ...     self._list.remove(item)
    ...   def __len__(self):
    ...     return len(self._list)
    ...   def __getitem__(self, sliced):
    ...     return self._list[sliced]
    ...   def __setitem__(self, sliced, val):
    ...     self._list[sliced] = val
    ...   def __delitem__(self, sliced):
    ...     del self._list[sliced]
    ...   def __contains__(self, item):
    ...     return item in self._list
    ...   def __iter__(self):
    ...     return iter(self._list)
    ...
    >>> emul = EmuList(range(5))
    >>> emul
    EmuList: [0, 1, 2, 3, 4]
    >>> emul[1:3]  #  __getitem__
    [1, 2]
    >>> emul[0:4:2]  #  __getitem__
    [0, 2]
    >>> len(emul)  #  __len__
    5
    >>> emul.append(5)
    >>> emul
    EmuList: [0, 1, 2, 3, 4, 5]
    >>> emul.remove(2)
    >>> emul
    EmuList: [0, 1, 3, 4, 5]
    >>> emul[3] = 6  # __setitem__
    >>> emul
    EmuList: [0, 1, 3, 6, 5]
    >>> 0 in emul  # __contains__
    True


仿写字典
--------

.. code-block:: python

    >>> class EmuDict(object):
    ...   def __init__(self, dict_):
    ...     self._dict = dict_
    ...   def __repr__(self):
    ...     return "EmuDict: " + repr(self._dict)
    ...   def __getitem__(self, key):
    ...     return self._dict[key]
    ...   def __setitem__(self, key, val):
    ...     self._dict[key] = val
    ...   def __delitem__(self, key):
    ...     del self._dict[key]
    ...   def __contains__(self, key):
    ...     return key in self._dict
    ...   def __iter__(self):
    ...     return iter(self._dict.keys())
    ...
    >>> _ = {"1":1, "2":2, "3":3}
    >>> emud = EmuDict(_)
    >>> emud  # __repr__
    EmuDict: {'1': 1, '2': 2, '3': 3}
    >>> emud['1']  # __getitem__
    1
    >>> emud['5'] = 5  # __setitem__
    >>> emud
    EmuDict: {'1': 1, '2': 2, '3': 3, '5': 5}
    >>> del emud['2']  # __delitem__
    >>> emud
    EmuDict: {'1': 1, '3': 3, '5': 5}
    >>> for _ in emud: print emud[_],  # __iter__
    ...
    1 3 5
    >>> '1' in emud  # __contains__
    True


仿写矩阵乘法
------------

.. code-block:: python

    # PEP 465 - 使用 "@" 表示矩阵乘法
    #
    # Python-3.5 以上版本

    >>> class Arr:
    ...     def __init__(self, *arg):
    ...         self._arr = arg
    ...     def __matmul__(self, other):
    ...         if not isinstance(other, Arr):
    ...             raise TypeError
    ...         if len(self) != len(other):
    ...             raise ValueError
    ...         return sum([x*y for x, y in zip(self._arr, other._arr)])
    ...     def __imatmul__(self, other):
    ...         if not isinstance(other, Arr):
    ...             raise TypeError
    ...         if len(self) != len(other):
    ...             raise ValueError
    ...         res = sum([x*y for x, y in zip(self._arr, other._arr)])
    ...         self._arr = [res]
    ...         return self
    ...     def __len__(self):
    ...         return len(self._arr)
    ...     def __str__(self):
    ...         return self.__repr__()
    ...     def __repr__(self):
    ...         return "Arr({})".format(repr(self._arr))
    ...
    >>> a = Arr(9, 5, 2, 7)
    >>> b = Arr(5, 5, 6, 6)
    >>> a @ b  # __matmul__
    124
    >>> a @= b  # __imatmul__
    >>> a
    Arr([124])


装饰器
------

.. code-block:: python

    # 见: PEP318
    >>> from functools import wraps
    >>> def decorator(func):
    ...   @wraps(func)
    ...   def wrapper(*args, **kwargs):
    ...     print "Before calling {}.".format(func.__name___)
    ...     ret = func(*args, **kwargs)
    ...     print "After calling {}.".format(func.__name___)
    ...     return ret
    ...   return wrapper
    ...
    >>> @decorator
    ... def example():
    ...   print "Inside example function."
    ...
    >>> example()
    Before calling example.
    Inside example function.
    After calling example.

    # 等价于
    ... def example():
    ...   print "Inside example function."
    ...
    >>> example = decorator(example)
    >>> example()
    Before calling example.
    Inside example function.
    After calling example.

.. note::

    ``@wraps`` 保留了原函数的属性,
    否则被修饰函数的属性会被 **装饰函数** 替换

.. code-block:: python

    # 不使用 @wraps
    >>> def decorator(func):
    ...     def wrapper(*args, **kwargs):
    ...         print('wrap function')
    ...         return func(*args, **kwargs)
    ...     return wrapper
    ...
    >>> @decorator
    ... def example(*a, **kw):
    ...     pass
    ...
    >>> example.__name__  # 函数属性改变
    'wrapper'

    # 使用 @wraps
    >>> from functools import wraps
    >>> def decorator(func):
    ...     @wraps(func)
    ...     def wrapper(*args, **kwargs):
    ...         print('wrap function')
    ...         return func(*args, **kwargs)
    ...     return wrapper
    ...
    >>> @decorator
    ... def example(*a, **kw):
    ...     pass
    ...
    >>> example.__name__  # 函数属性保留
    'example'


带参数的装饰器
--------------

.. code-block:: python

    >>> from functools import wraps
    >>> def decorator_with_argument(val):
    ...   def decorator(func):
    ...     @wraps(func)
    ...     def wrapper(*args, **kwargs):
    ...       print "Val is {0}".format(val)
    ...       return func(*args, **kwargs)
    ...     return wrapper
    ...   return decorator
    ...
    >>> @decorator_with_argument(10)
    ... def example():
    ...   print "This is example function."
    ...
    >>> example()
    Val is 10
    This is example function.

    # 等价于
    >>> def example():
    ...   print "This is example function."
    ...
    >>> example = decorator_with_argument(10)(example)
    >>> example()
    Val is 10
    This is example function.

for-else 语句
-------------

.. code-block:: python

    # 见文章: More Control Flow Tools
    # for 循环的 else 在没有 break 产生的情况下执行
    >>> for _ in range(5):
    ...   print _,
    ... else:
    ...   print "\nno break occurred"
    ...
    0 1 2 3 4
    no break occurred
    >>> for _ in range(5):
    ...   if _ % 2 == 0:
    ...     print "break occurred"
    ...     break
    ... else:
    ...   print "no break occurred"
    ...
    break occurred

    # 等价于
    flag = False
    for _ in range(5):
        if _ % 2 == 0:
            flag = True
            print "break occurred"
            break
    if flag == False:
        print "no break occurred"

try-else 语句
-------------

.. code-block:: python

    # 没有异常是执行 else 中的语句
    >>> try:
    ...   print "No exception"
    ... except:
    ...   pass
    ... else:
    ...   print "No exception occurred"
    ...
    No exception
    No exception occurred

Lambda 表达式
-------------

.. code-block:: python

    >>> fn = lambda x: x**2
    >>> fn(3)
    9
    >>> (lambda x: x**2)(3)
    9
    >>> (lambda x: [x*_ for _ in range(5)])(2)
    [0, 2, 4, 6, 8]
    >>> (lambda x: x if x>3 else 3)(5)
    5

    # 多行 lambda 表达式
    >>> (lambda x:
    ... True
    ... if x>0
    ... else
    ... False)(3)
    True

不定参数 - (\*args, \*\*kwargs)
-------------------------------

.. code-block:: python

    >>> def example(a, b=None, *args, **kwargs):
    ...   print a, b
    ...   print args
    ...   print kwargs
    ...
    >>> example(1, "var", 2, 3, word="hello")
    1 var
    (2, 3)
    {'word': 'hello'}
    >>> a_tuple = (1, 2, 3, 4, 5)
    >>> a_dict = {"1":1, "2":2, "3":3}
    >>> example(1, "var", *a_tuple, **a_dict)
    1 var
    (1, 2, 3, 4, 5)
    {'1': 1, '2': 2, '3': 3}

``type()`` 声明（创建） ``class``
----------------------------------

.. code-block:: python

    >>> def fib(self, n):
    ...     if n <= 2:
    ...         return 1
    ...     return fib(self, n-1) + fib(self, n-2)
    ...
    >>> Fib = type('Fib', (object,), {'val': 10,
    ...                               'fib': fib})
    >>> f = Fib()
    >>> f.val
    10
    >>> f.fib(f.val)
    55

    # 等价于
    >>> class Fib(object):
    ...     val = 10
    ...     def fib(self, n):
    ...         if n <=2:
    ...             return 1
    ...         return self.fib(n-1)+self.fib(n-2)
    ...
    >>> f = Fib()
    >>> f.val
    10
    >>> f.fib(f.val)
    55


Callable 对象
--------------

.. code-block:: python

    >>> class CallableObject(object):
    ...   def example(self, *args, **kwargs):
    ...     print "I am callable!"
    ...   def __call__(self, *args, **kwargs):
    ...     self.example(*args, **kwargs)
    ...
    >>> ex = CallableObject()
    >>> ex()
    I am callable!

上下文管理 - ``with`` 语句
--------------------------

.. code-block:: python

    # 代替 try: ... finally: ...
    # 见: PEP343
    # 常用于 open 和 close 操作

    import socket

    class Socket(object):
        def __init__(self,host,port):
            self.host = host
            self.port = port

        def __enter__(self):
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.bind((self.host,self.port))
            sock.listen(5)
            self.sock = sock
            return self.sock

        def __exit__(self, *exc_info):
            if exc_info[0] is not None:
                import traceback
                traceback.print_exception(*exc_info)
            self.sock.close()

    if __name__=="__main__":
        host = 'localhost'
        port = 5566
        with Socket(host, port) as s:
            while True:
                conn, addr = s.accept()
                msg = conn.recv(1024)
                print msg
                conn.send(msg)
                conn.close()

使用 ``@contextmanager``
--------------------------

.. code-block:: python

    from contextlib import contextmanager

    @contextmanager
    def opening(filename, mode='r'):
       f = open(filename, mode)
       try:
          yield f
       finally:
          f.close()

    with opening('example.txt') as fd:
       fd.read()

用 ``with`` 语句打开文件
------------------------

.. code-block:: python

    >>> with open("/etc/passwd",'r') as f:
    ...    content = f.read()

Property - 管理属性
-------------------

.. code-block:: python

    >>> class Example(object):
    ...     def __init__(self, value):
    ...        self._val = value
    ...     @property
    ...     def val(self):
    ...         return self._val
    ...     @val.setter
    ...     def val(self, value):
    ...         if not isintance(value, int):
    ...             raise TypeError("Expected int")
    ...         self._val = value
    ...     @val.deleter
    ...     def val(self):
    ...         del self._val
    ...
    >>> ex = Example(123)
    >>> ex.val = "str"
    Traceback (most recent call last):
      File "", line 1, in
      File "test.py", line 12, in val
        raise TypeError("Expected int")
    TypeError: Expected int

    # 等价于
    >>> class Example(object):
    ...     def __init__(self, value):
    ...        self._val = value
    ...
    ...     def _val_getter(self):
    ...         return self._val
    ...
    ...     def _val_setter(self, value):
    ...         if not isintance(value, int):
    ...             raise TypeError("Expected int")
    ...         self._val = value
    ...
    ...     def _val_deleter(self):
    ...         del self._val
    ...
    ...     val = property(fget=_val_getter, fset=_val_setter, fdel=_val_deleter, doc=None)
    ...

计算属性（延迟加载） - 使用 property
-------------------------------------

.. code-block:: python

    >>> class Example(object):
    ...   @property
    ...   def square3(self):
    ...     return 2**3
    ...
    >>> ex = Example()
    >>> ex.square3
    8

.. note::

    ``@property`` 在我们需要的时候才会计算属性的值，
    并不是事先就在内存中存储

描述器 - 管理属性
-----------------

.. code-block:: python

    >>> class Integer(object):
    ...   def __init__(self, name):
    ...     self._name = name
    ...   def __get__(self, inst, cls):
    ...     if inst is None:
    ...       return self
    ...     else:
    ...       return inst.__dict__[self._name]
    ...   def __set__(self, inst, value):
    ...     if not isinstance(value, int):
    ...       raise TypeError("Expected int")
    ...     inst.__dict__[self._name] = value
    ...   def __delete__(self,inst):
    ...     del inst.__dict__[self._name]
    ...
    >>> class Example(object):
    ...   x = Integer('x')
    ...   def __init__(self, val):
    ...     self.x = val
    ...
    >>> ex1 = Example(1)
    >>> ex1.x
    1
    >>> ex2 = Example("str")
    Traceback (most recent call last):
      File "<stdin>", line 1, in <module>
      File "<stdin>", line 4, in __init__
      File "<stdin>", line 11, in __set__
    TypeError: Expected an int
    >>> ex3 = Example(3)
    >>> hasattr(ex3, 'x')
    True
    >>> del ex3.x
    >>> hasattr(ex3, 'x')
    False

``@staticmethod``, ``@classmethod``
-------------------------------------

.. code-block:: python

    # @classmethod: 绑定 class
    # @staticmethod: 和 python 方法类似，只是在类里面
    >>> class example(object):
    ...   @classmethod
    ...   def clsmethod(cls):
    ...     print "I am classmethod"
    ...   @staticmethod
    ...   def stmethod():
    ...     print "I am staticmethod"
    ...   def instmethod(self):
    ...     print "I am instancemethod"
    ...
    >>> ex = example()
    >>> ex.clsmethod()
    I am classmethod
    >>> ex.stmethod()
    I am staticmethod
    >>> ex.instmethod()
    I am instancemethod
    >>> example.clsmethod()
    I am classmethod
    >>> example.stmethod()
    I am staticmethod
    >>> example.instmethod()
    Traceback (most recent call last):
      File "", line 1, in
    TypeError: unbound method instmethod() ...

抽象方法 - 元类（Metaclass）
----------------------------

.. code-block:: python

    # 通常用于定义抽象方法（没有实现的方法）
    >>> from abc import ABCMeta, abstractmethod
    >>> class base(object):
    ...   __metaclass__ = ABCMeta
    ...   @abstractmethod
    ...   def absmethod(self):
    ...     """ Abstract method """
    ...
    >>> class example(base):
    ...   def absmethod(self):
    ...     print "abstract"
    ...
    >>> ex = example()
    >>> ex.absmethod()
    abstract

    # 更优雅定义抽象类的方法
    >>> class base(object):
    ...   def absmethod(self):
    ...     raise NotImplementedError
    ...
    >>> class example(base):
    ...   def absmethod(self):
    ...     print "abstract"
    ...
    >>> ex = example()
    >>> ex.absmethod()
    abstract

常用 **Magic** 方法
-------------------

.. code-block:: python

    # 见 python 文档: data model
    # 一般类
    __main__
    __name__
    __file__
    __module__
    __all__
    __dict__
    __class__
    __doc__
    __init__(self, [...)
    __str__(self)
    __repr__(self)
    __del__(self)

    # 描述
    __get__(self, instance, owner)
    __set__(self, instance, value)
    __delete__(self, instance)

    # 上线文管理
    __enter__(self)
    __exit__(self, exc_ty, exc_val, tb)

    # 仿写容器
    __len__(self)
    __getitem__(self, key)
    __setitem__(self, key, value)
    __delitem__(self, key)
    __iter__(self)
    __contains__(self, value)

    # 属性操作
    __getattr__(self, name)
    __setattr__(self, name, value)
    __delattr__(self, name)
    __getattribute__(self, name)

    # Callable 对象
    __call__(self, [args...])

    # 比较
    __cmp__(self, other)
    __eq__(self, other)
    __ne__(self, other)
    __lt__(self, other)
    __gt__(self, other)
    __le__(self, other)
    __ge__(self, other)

    # 数学操作
    __add__(self, other)
    __sub__(self, other)
    __mul__(self, other)
    __div__(self, other)
    __mod__(self, other)
    __and__(self, other)
    __or__(self, other)
    __xor__(self, other)


分析 csv
---------

.. code-block:: python

    # python2 和 python3 兼容

    >>> try:
    ...     from StringIO import StringIO  # python2 用法
    ... except ImportError:
    ...     from io import StringIO  # python3 用法
    ...
    >>> import csv
    >>> s = "foo,bar,baz"
    >>> f = StringIO(s)
    >>> for x in csv.reader(f): print(x)
    ...
    ['foo', 'bar', 'baz']

    # 或者

    >>> import csv
    >>> s = "foo,bar,baz"
    >>> for x in csv.reader([s]): print(x)
    ...
    ['foo', 'bar', 'baz']
