# Convention

## 단계

* 전제(Given)
** 주어로 시작하는 현재형을 사용한다
```
users_exist
```

* 실행(When)
** 명령형을 사용한다.
```
request_authorization_code
```

* 확인(Then)
** 주어로 시작하는 should문을 사용한다.
```
authorization_code_should_be_valid
```

## Capybara and Rack 테스트

* User가 액터 경우 Capybara 테스트를 사용한다.
* 나머지 테스트는 Rack 테스트를 사용한다.
