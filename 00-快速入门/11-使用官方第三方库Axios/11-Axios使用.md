[TOC]

> [鸿蒙axios仓库地址](https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Faxios)
>
> [js axios使用说明](https://www.axios-http.cn/docs/example)

# 依赖添加

第三方库是一个静态的，我们只需要在对应的module下面添加就好。比如：`entry->oh-package.json5`

```typescript
"dependencies": {
  "@ohos/axios": "^2.2.2"
}
```



**推荐：直接命令行输入**

到官方库位置：[axios](https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Faxios)查看文档 有一个下载命令`ohpm install @ohos/axios`

```shell
# w in ~/project/mystudyproject/AxiosDemo
$ ls          
AppScope              entry                 hvigorfile.ts         oh-package-lock.json5 oh_modules
build-profile.json5   hvigor                local.properties      oh-package.json5
(base) 
# w in ~/project/mystudyproject/AxiosDemo
$ cd entry         
(base) 
# w in ~/project/mystudyproject/AxiosDemo/entry
$ ohpm install @ohos/axios

ohpm INFO: MetaDataFetcher fetching meta info of package '@ohos/axios' from https://ohpm.openharmony.cn/ohpm/
ohpm INFO: fetch meta info of package '@ohos/axios' success https://ohpm.openharmony.cn/ohpm/@ohos/axios
ohpm INFO: fetch package done 1 @ohos/axios from https://contentcenter-drcn.dbankcdn.cn/pub_1/DevEcoSpace_DevEcoSpace_901_9/59/v3/2afb94e1-fdb4-4fb6-bc27-d782cc01fbd1/axios-2.2.2.har
install completed in 0s 985ms
(base) 

```

自动在依赖文件中添加了

```typescript
"dependencies": {
  "@ohos/axios": "^2.2.2"
}
```



**最后网络请求权限不能少**

```typescript
'requestPermissions': [
	{"name": "ohos.permission.INTERNET"}
],
"abilities": [.......
```



# 其他命令

- 更新库依赖： `ohpm update`更新当前路径下所有第三方库
- 更新单个第三方库：`ohpm update <package_name>`
- 查看三方库信息：`ohpm info <package_name>`



# [基础使用-官方文档](https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Faxios)



# 二次封装



# TS内置类型

TypeScript 提供了一组内置的实用类型（Utility Types）来帮助开发者在类型定义时更灵活和方便地处理各种场景。这些实用类型能够基于已有类型创建新的类型，从而提高代码的可维护性和可读性。

### 常用的内置实用类型

1. **`Partial<Type>`**
   - 构造一个类型，将 Type 的所有属性设置为可选。
   ```typescript
   interface User {
     id: number;
     name: string;
     age: number;
   }
   
   type PartialUser = Partial<User>;
   
   const user: PartialUser = { id: 1, name: "Alice" }; // age 属性可以省略
   ```

2. **`Required<Type>`**
   - 构造一个类型，将 Type 的所有属性设置为必选。
   ```typescript
   interface User {
     id?: number;
     name?: string;
     age?: number;
   }
   
   type RequiredUser = Required<User>;
   
   const user: RequiredUser = { id: 1, name: "Alice", age: 30 }; // 所有属性都必须存在
   ```

3. **`Readonly<Type>`**
   - 构造一个类型，将 Type 的所有属性设置为只读。
   ```typescript
   interface User {
     id: number;
     name: string;
   }
   
   type ReadonlyUser = Readonly<User>;
   
   const user: ReadonlyUser = { id: 1, name: "Alice" };
   // user.id = 2; // Error: Cannot assign to 'id' because it is a read-only property.
   ```

4. **`Record<Keys, Type>`**
   - 构造一个对象类型，其属性键为 Keys，属性值类型为 Type。
   ```typescript
   type StringNumberMap = Record<string, number>;
   
   const example: StringNumberMap = {
     key1: 1,
     key2: 2,
   };
   ```

5. **`Pick<Type, Keys>`**
   - 构造一个类型，从 Type 中选取一组属性 Keys。
   ```typescript
   interface User {
     id: number;
     name: string;
     age: number;
   }
   
   type UserName = Pick<User, "name">;
   
   const user: UserName = { name: "Alice" };
   ```

6. **`Omit<Type, Keys>`**
   - 构造一个类型，从 Type 中剔除一组属性 Keys。
   ```typescript
   interface User {
     id: number;
     name: string;
     age: number;
   }
   
   type UserWithoutAge = Omit<User, "age">;
   
   const user: UserWithoutAge = { id: 1, name: "Alice" };
   ```

7. **`Exclude<Type, ExcludedUnion>`**
   - 从 Type 中排除所有的 ExcludedUnion 类型。
   ```typescript
   type T0 = Exclude<"a" | "b" | "c", "a">; // "b" | "c"
   ```

8. **`Extract<Type, Union>`**
   - 从 Type 中提取所有的 Union 类型。
   ```typescript
   type T0 = Extract<"a" | "b" | "c", "a" | "f">; // "a"
   ```

9. **`NonNullable<Type>`**
   - 构造一个类型，将 Type 中的 null 和 undefined 排除掉。
   ```typescript
   type T0 = NonNullable<string | number | undefined>; // string | number
   ```

10. **`ReturnType<Type>`**
    - 构造一个类型，表示函数 Type 的返回值类型。
    ```typescript
    function f1() {
      return { x: 10, y: 3 };
    }
    
    type T0 = ReturnType<typeof f1>; // { x: number; y: number; }
    ```

11. **`InstanceType<Type>`**
    - 构造一个类型，表示构造函数 Type 的实例类型。
    ```typescript
    class C {
      x = 0;
      y = 0;
    }
    
    type T0 = InstanceType<typeof C>; // C
    ```

12. **`ThisType<Type>`**
    - 用于在对象字面量方法中强制使用某个类型。
    ```typescript
    type ObjectDescriptor<D, M> = {
      data?: D;
      methods?: M & ThisType<D & M>; // Type of 'this' in methods is D & M
    };
    
    function makeObject<D, M>(desc: ObjectDescriptor<D, M>): D & M {
      const data: object = desc.data || {};
      const methods: object = desc.methods || {};
      return { ...data, ...methods } as D & M;
    }
    
    let obj = makeObject({
      data: { x: 0, y: 0 },
      methods: {
        moveBy(dx: number, dy: number) {
          this.x += dx; // Strongly typed this
          this.y += dy; // Strongly typed this
        },
      },
    });
    
    obj.x = 10;
    obj.y = 20;
    obj.moveBy(5, 5);
    ```

这些实用类型大大增强了 TypeScript 类型系统的灵活性和表达力，帮助开发者更方便地进行类型操作和转换。
