# Objective C Container Performance Compare
 
#### Compre in case of low element count which less than 4000.
 ![image](https://raw.githubusercontent.com/shuice/Objective-C-Container-Performance-Compare/master/1.png)
 
 
 
 
 
#### Compre in case of huge element count that reaches less than 32000
 ![image](https://raw.githubusercontent.com/shuice/Objective-C-Container-Performance-Compare/master/2.png)
 
 
 
 
 
#### Base on last compare, add two function``-[NSArray containsObject:]`` and ``-[NSArray removeObject:]``, this two functions take too much time.
 
 ![image](https://raw.githubusercontent.com/shuice/Objective-C-Container-Performance-Compare/master/3.png)
 
 
