import relationalStore from '@ohos.data.relationalStore';

@Entry
@Component
struct SqlPage {
  private context = getContext(this)
  private rdbStore: relationalStore.RdbStore | undefined
  private count = 0

  aboutToAppear() {
    const CREATE_TABLE_TEST = 'CREATE TABLE IF NOT EXISTS test (' +
    '_id INTEGER PRIMARY KEY,' +
    'name TEXT NOT NULL,' +
    'age INTEGER,' +
    'salary REAL,' +
    'date TEXT)';

    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: 'RdbTest.db',
      securityLevel: relationalStore.SecurityLevel.S1
    }
    relationalStore.getRdbStore(this.context, STORE_CONFIG, (error, rdbStore) => {
      if (error) {
        console.error(`数据库获取错误：${error.message}`)
        return
      }
      this.rdbStore = rdbStore
      this.rdbStore.executeSql(CREATE_TABLE_TEST)
      console.log('创建数据库成功')
    })
  }

  build() {
    Column() {
      Button('插入数据')
        .fontSize(20)
        .margin(20)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.count++
          let m: relationalStore.ValuesBucket = {
            'name': `wdd${this.count}`,
            'age': this.count,
            'salary': this.count * 100.01,
            'date': `2024/06/13 88:0${this.count}`
          }
          this.rdbStore.insert('test', m, (error, rawId) => {
            if (error) {
              console.error(`数据库插入失败：${error.message}`)
              return
            }
            console.log(`创建数据库插入成功${rawId}`)
          })
        })

      Button('查询数据')
        .fontSize(20)
        .margin(20)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          let predicates = new relationalStore.RdbPredicates("test")
          predicates.isNotNull('name')
          this.rdbStore.query(predicates, ["_id", "name", "age", "salary", "date"], (error, resultSet) => {
            if (error) {
              console.error(`数据库查询失败：${error.message}`)
              return
            }
            while (resultSet.goToNextRow()) {
              let _id = resultSet.getLong(resultSet.getColumnIndex("_id"))
              let name = resultSet.getString(resultSet.getColumnIndex("name"))
              let age = resultSet.getLong(resultSet.getColumnIndex("age"))
              let salary = resultSet.getDouble(resultSet.getColumnIndex("salary"))
              let date = resultSet.getString(resultSet.getColumnIndex("date"))
              console.info(`数据库查询结果：${_id},${name},${age},${salary},${date}`)
            }
          })
        })
    }
    .width('100%')
  }
}