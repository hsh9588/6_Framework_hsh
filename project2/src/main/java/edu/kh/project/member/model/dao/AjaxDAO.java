package edu.kh.project.member.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository // DB 연결하는 역할이다 + bean 등록 (bean : spring framework가 관리하는 객체)
public class AjaxDAO {

	@Autowired // 같은 자료형이 bean으로 등록 되어 있으면 자동으로 DI(의존성 )
	private SqlSessionTemplate sqlSession;
	// SqlSessionTemplate : 커넥션 + 마이바티스 + 스프링 TX 제어 

	/** 이메일 중복 검사 DAO
	 * @param memberEmail
	 * @return result
	 */
	public int emailDupCheck(String memberEmail) {
		
		return sqlSession.selectOne("ajaxMapper.emailDupCheck", memberEmail);
	}
	
}
