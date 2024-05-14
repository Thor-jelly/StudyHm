[TOC]

# JavaScript 与 TypeScript 介绍



## JavaScript 介绍

JavaScript 是一种广泛使用的动态编程语言，常用于Web和前端应用开发

- 动态性：**变量类型可以在运行时更改**
- 浏览器支持：所有现代浏览器都支持
- 简洁灵活：语法简单易学
- 事件驱动：擅长处理用户交互和动态网页效果



## TypeScript 介绍

- **类型支持提供了静态类型检查**，有助于提高代码的可读性和可维护性
- 强大工具与现代开发工具集成良好，提供智能提示和自动完成等功能
- 面向对象更好的编程风格
- 代码重构
- 代码重构更安全和容易



# ArkTS 介绍



## 背景

ArkTS 在保持 TypeScript 基本语法风格的基础上，进一步通过规范强化静态检查和分析，使得在程序开发期能检测更多错误，提升程序稳定性，并实现更好的运行性能。



**ArkTS 强制使用静态类型，通过更严格类型检查以减少运行时错误。**



一些限制：

- 强制使用严格模式（use script）
- 禁止使用eval()
- 禁止使用with() {}
- 禁止以字符串为代码创建函数
- 禁止使用var，只能使用let
- 禁止使用any类型
- 禁止删除(delete)对象中某个属性
- 禁止使用Symbol
- 禁止使用[] 索引访问对象属性
- 一元运算`+`只能作用于数值类型
- 不支持structural typing（结构化类型等效）

​	定义的两个类属性跟方法完全一致，在**TS**中`let u:U = new T();`是可以的

- `JSON.parse`标注返回类型，Record<x,x> 相当于map类型 key value



## 基本知识



### 声明

ArkTS 可以通过关键字 `let` 声明变量，`const` 声明常量。通过类型注释指定类型。

1. 语法

​	关键字  变量/常量名: 类型注释 = 值

2. 声明变量

​	let count: number = 0

3. 声明常量

​	const MAX_COUNT: number = 110



### 类型

- 基本类型：string，number，boolean，enum

  ```
  let name: string = 'wdd'
  let age: number = 18
  let isMale: boolean = true
  
  enum Color {
  	Red, Blue, Green
  }
  
  let bgColor: Color = Color.Red
  ```

- 引用类型：Array，自定义类

  ```
  let students: Array<string> = ['zs', 'ls', 'ww']
  let students: string[] = ['zs', 'ls', 'ww']
  
  class Person {...}
  let person: Person = new Person()
  ```

- 联合类型：Union 允许变量的值为多个类型

  ```
  let id: number|string = 1
  id = '110'
  ```

- 类型别名：Aliases 允许给一个类型取别名，方便理解和复用

  ```
  type Matrix = number[][]
  type NullableObject = Object|null
  ```



### 空安全

- 声明变量可以空

  ```
  let name: string|null = null
  console.log(name.length.toString())//报错，变量可能为null 无法获取null的length
  ```

- 空安全判断

  ```
  //1.用 if/else 判断
  if(name != null){...} 
  
  //2.空值合并表达式，??左边为空时，返回??右边的值
  const unwrapped = name ?? ''
  
  //3.?可选链，如果name为null，运算符返回undefined
  let len = name?.length
  ```



### 类型判断与类型推断

ArkTS时类型安全的语言，编译器会进行类型检查

```
let name: string = 'zs'
name = 20//报错，number不能赋值给string类型变量
```

ArkTS可以省略类型声明，此时会自动推导类型

```
let age = 18 //age自动推断为number类型
```



### 语句

#### 条件语句：根据条件真值（true或false）执行不同的代码块

1. 条件语句

   ```
   let age = 100
   let pass = false
   if(age >= 89) {
     pass = true
   }else {
     pass = false
   }
   ```

   

2. 条件表达式

   ```
   let age = 100
   let pass = age >= 89 ? true : false
   ```

   

#### 循环语句：用于重复执行的语句

```
let s = ['zs', 'ls', 'ww']

//1.for循环
for(let i =. 0; i < s.length; i++){
	console.log(s[i])
}

//2.for...of循环
for(let str of s){
	console.log(str)
}

//3.while循环
let index = 0
while(index < s.length){
	console.log(s[i])
	index++
}
```



## 函数声明和使用

函数时多条语句的组合，一个可重复的代码块



1. 用`function`声明函数

   ```
   function 函数名(
   	参数1: 参数类型1,
   	参数2: 参数类型2
   ):返回类型 {
   	//函数体
   }
   
   
   //定义一个函数
   function printPersons(persons: string[]): void{
   	for(let p of persons){
   		console.log(p)
   	}
   }
   //调用函数
   printPersons(['zs', 'ls', 'ww'])
   ```

   

2. 箭头函数/lambda：简化声明，匿名函数。通常用于把函数作为参数传递。

   `(参数1: 参数类型1, 参数2: 参数类型2): 返回类型 => {//函数体}`

   ```
   (name: string): void => {
   	console.log(name)
   }
   ```

   

3. 闭包函数：一个函数可以作为另一个函数的返回值。

   > 闭包本身没有直接的销毁方法，但通过解除对闭包内部变量的引用或将闭包本身设置为 `null`，可以确保不再需要的内存能够被垃圾回收机制回收。养成良好的编码习惯，尽量将闭包的使用限制在局部作用域内，可以有效避免内存泄漏问题。

   ```
   type returnType = () => string
   
   function outerFunc():()=>string{
   	let count = 0
   	return ():string => {
   		count++
   		return count.toString()
   	}
   }
   
   let invoker = outerFunc()
   console.log(invoker())//输出1
   console.log(invoker())//输出2
   ```



## 类的声明和使用

- 类的声明

  ArkTS 支持面向对象编程。可声明对象属性和方法。

  ```
  class Person{
  	name: string = 'zs'
  	age: number = 18
  	isMale: boolean = true
  }
  ```

- 创建类的实例

  ```
  const person = new Person()
  console.log(person.name)
  
  const person: Person = {
  	name: string = 'zs',
  	age: number = 18,
  	isMale: boolean = true
  }
  console.log(person.name)
  ```

- 构造器

  ```
  class Person{
  	name: string = 'zs'
  	age: number = 18
  	isMale: boolean = true
  	
  	//声明自定义构造器
  	constructor(name: string, age: number, isMale: boolean){
  		this.name = name
  		this.age = age
  		this.isMale = isMale
  	}
  }
  
  //使用构造器
  const person = new Person('zs', 20, false)
  console.log(person.name)
  ```

- 实例方法

  ```
  class Person{
  	name: string = 'zs'
  	age: number = 18
  	isMale: boolean = true
  	
  	constructor(name: string, age: number, isMale: boolean){
  		this.name = name
  		this.age = age
  		this.isMale = isMale
  	}
  	
  	//声明实例方法
  	printInfo() {
  		console.log(`我叫${name}，年龄${age}，性别${isMale}`)
  	}
  }
  
  
  const person = new Person('zs', 20, false)
  //调用实例方法
  person.printInfo()
  ```

- 封装：将数据隐藏起来，对外提供接口来访问。

  ```
  class Person{
  	//可见性操作符，默认为public
  	public name: string = 'zs'
  	//私有的
  	private age: number = 18
  	isMale: boolean = true
  	
  	constructor(name: string, age: number, isMale: boolean){
  		this.name = name
  		this.age = age
  		this.isMale = isMale
  	}
  	
  	get age(): number{
  		return this.age
  	}
  	
  	set age(age: number){
  		this._age = age
  	}
  }
  
  const person = new Person('zs', 20, false)
  console.log(person.age.toString())
  ```

- 继承：子类继承父类的特征和行为，关键字extends。

  ```
  class DPerson extends Person {
  	des: string
  	
  	//重写父类构造函数
  	constructor(name: string, age: number, isMale: boolean, des: string){
  		//调用父类构造函数
  		super(name, age, isMale)
  		this.des = des
  	}
  }
  
  const luFei: DPerson = new DPerson('路飞', 20, true, "蒙蒂奇路飞")
  //调用父类实例方法
  luFei.printInfo()
  ```

- 多态：子类继承父类，可以重写父类方法

  ```
  class DPerson extends Person {
  	des: string
  	
  	constructor(name: string, age: number, isMale: boolean, des: string){
  		super(name, age, isMale)
  		this.des = des
  	}
  	
  	//重写父类实例方法
  	printInfo(): void{
  		super.printInfo()
  		console.log(`全称：${this.des}`)
  	}
  }
  
  const person = new Person('zs', 20, false)
  //调用父类实例方法
  console.log(person.age.toString())
  
  const luFei: DPerson = new DPerson('路飞', 20, true, "蒙蒂奇路飞")
  //调用子类重写的实例方法
  luFei.printInfo()
  ```



## 模块导出与导入

- ArkTS 中文件内的作用域是独立的

- 通过`export`导出文件中的额变量、函数、类等。

  ```
  //export导出Person类
  export class Person{
  	name: string = 'zs'
  	age: number = 18
  	isMale: boolean = true
  	
  	constructor(name: string, age: number, isMale: boolean){
  		this.name = name
  		this.age = age
  		this.isMale = isMale
  	}
  	
  	printInfo() {
  		console.log(`我叫${name}，年龄${age}，性别${isMale}`)
  	}
  }
  
  const person = new Person('zs', 20, false)
  person.printInfo()
  ```

- 通过`import`导入另一个文件中的变量、函数、类等。

  ```
  //import导入Person类
  import {Person} from './Person'
  
  const person = new Person('ww', 11, false)
  person.printInfo()
  ```

  
