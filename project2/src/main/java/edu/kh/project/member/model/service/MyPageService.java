package edu.kh.project.member.model.service;

import java.util.Map;

import edu.kh.project.member.model.vo.Member;

public interface MyPageService {

	/** 회원 정보 수정 서비스
	 * @param inputMember
	 * @return result
	 */
	/* public abstract */ int updateInfo(Member inputMember);

	int changePw(Map<String, Object> paramMap);

}
