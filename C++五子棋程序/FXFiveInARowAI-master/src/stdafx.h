// stdafx.h : ��׼ϵͳ�����ļ��İ����ļ���
// ���Ǿ���ʹ�õ��������ĵ�
// �ض�����Ŀ�İ����ļ�
//

#pragma once

#include "targetver.h"

#define WIN32_LEAN_AND_MEAN             // �� Windows ͷ���ų�����ʹ�õ�����
// Windows ͷ�ļ�: 
#include <windows.h>

// C ����ʱͷ�ļ�
#include <stdlib.h>
#include <malloc.h>
#include <memory.h>
#include <tchar.h>
#include <vector>
#include <algorithm>
#include <random>



#ifdef _DEBUG
//#define TEST
#define ASSERT(exp)	\
	if (!(exp))		\
		__asm { int 3}
#else
#define ASSERT(exp)	0
#endif

#define CHECK_ASSERT_RET_FALSE(exp)	\
	ASSERT(exp);					\
	if (!exp) return false;

#define CHECK_RET_FALSE(exp)	\
	if (!exp) return false;


#define FIVE_IN_A_ROW

#ifdef FIVE_IN_A_ROW
#define CHESS_TYPE bool
#define CHESS_BLACK true
#define CHESS_WHITE false

#define FIVE 5
#define UNUSEFULL 0xffff
#endif

struct CHESS_POINT
{
	UINT16 row;
	UINT16 col;
	CHESS_POINT(const UINT16 & _row, const UINT16 & _col) : row(_row), col(_col){}
};

// TODO: �ڴ˴����ó�����Ҫ������ͷ�ļ�
