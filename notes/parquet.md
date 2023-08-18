---
title: Apache Parquet
---

> [Apache Parquet] is an open source, column-oriented data file format designed
> for efficient data storage and retrieval.
> It provides efficient data compression and encoding schemes with enhanced
> performance to handle complex data in bulk. Parquet is available in multiple
> languages including Java, C++, Python, etc...

- 데이터 파일 포맷이다.
- 컬럼 기반이다.
- 데이터 저장, 검색에 효율적.
- 복잡한 데이터를 한 번에 다룰 때 유용하다.
- 다양한 언어를 지원한다.

[Apache Parquet]: https://parquet.apache.org/

## 컬럼 기반

일반적인 데이터베이스, 파일 시스템은 row-oriented, 행 기반 시스템이다.
각각의 대상에 대하여 정보 집약적이다.
새로운 데이터를 추가할 때 빠르게 추가할 수 있다.

StudentID | Name     | Age | GPA
--------------------------------
1001      | John     | 20  | 3.5
1002      | Sarah    | 22  | 3.8
1003      | Michael  | 21  | 3.2

반대로 컬럼 기반(column-oriente) 시스템은 각각의 속성에 대하여 정보 집약적이다.
새로운 데이터를 추가하는 것은 상대적으로 비싸지만, 같은 특성을 가진 정보를
모아서 관리하기 때문에 압축률이 좋다. 또한 :

StudentID | 1001 | 1002 | 1003
------------------------------
Name      | John | Sarah| Michael
Age       | 20   | 22   | 21
GPA       | 3.5  | 3.8  | 3.2


