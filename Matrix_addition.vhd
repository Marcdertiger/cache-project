

-- Addition of two 5x5 matrices


-- matrix addition. result found in memory location mem[70]..mem[94]
--		(starts adding from top left corner then goes top-down following the columns)




		
		-- space for program mem[0..49]
		
0 =>  x"3019",		-- R0 = 25   (Start-up value of program counter)
1 =>  x"3132",		-- R1 = 50	 (position of first element of matrix a)
2 =>  x"324B",		-- R2 = 75	 (position of first element of matrix b)
3 =>  x"3301",		-- R3 = 1	 (constant 1)
4 =>  x"3464",		-- R4 = 100	(position of first element of matrix c (result matrix))

--5=>  x"112D",		-- M[45] <- R0 (M[45] is the position of matrix 0 pointer)				M[45]=50
--6=>  x"1242E",		-- M[46] <- R1 (M[46] is the position of matrix 1 pointer)				M[46]=75
--7=>  x"102F",		-- M[45] <- R0 (M[47] is the program counter, loop exits at 25 runs)	M[47]=0

--loop beginning
	5=>  x"8160",		-- R6    <- M[R1] (matrix 0 current element copied in R6)
	6=>  x"8270",		-- R7    <- M[R2] (matrix 0 current element copied in R7)
	7=> x"4678",		-- R8    <- R6 + R7
	8=> x"2480",		-- M[R4] <- R8 (R4 is matrix c pointer location)


	--increment pointers
	9=> x"5030",		-- decrement program counter
	10=> x"4131",		-- increment matrix a pointer
	11=> x"4232",		-- increment matrix b pointer
	12=> x"4434",		-- increment matrix c pointer

	16=> x"9005",		-- R0>25: PC<- #8  (0..24 = 25 operations done)
--loop end


17=> x"F000",		-- HALT

-- output values here, not written yet (will do once op codes and code above works)








--matrix a (columns created from left to right)(items in columnss are created top to bottom)

--column 0 

50 => x"0001",			-- Mem[50] = 0001
51 => x"0001",			-- Mem[51] = 0001
52 => x"0001",			-- Mem[52] = 0001
53 => x"0001",			-- Mem[53] = 0001
54 => x"0001",			-- Mem[54] = 0001

--column 1

55 => x"0001",			-- Mem[55] = 0001
56 => x"0001",			-- Mem[56] = 0001
57 => x"0001",			-- Mem[57] = 0001
58 => x"0001",			-- Mem[58] = 0001
59 => x"0001",			-- Mem[59] = 0001

--column 2

60 => x"0001",			-- Mem[60] = 0001
61 => x"0001",			-- Mem[61] = 0001
62 => x"0001",			-- Mem[62] = 0001
63 => x"0001",			-- Mem[63] = 0001
64 => x"0001",			-- Mem[64] = 0001

--column 3

65 => x"0001",			-- Mem[65] = 0001
66 => x"0001",			-- Mem[66] = 0001
67 => x"0001",			-- Mem[67] = 0001
68 => x"0001",			-- Mem[68] = 0001
69 => x"0001",			-- Mem[69] = 0001

--column 4

70 => x"0001",			-- Mem[70] = 0001
71 => x"0001",			-- Mem[71] = 0001
72 => x"0001",			-- Mem[72] = 0001
73 => x"0001",			-- Mem[73] = 0001
74 => x"0001",			-- Mem[74] = 0001



--matrix b (columns created from left to right)(items in colums are created top to bottom)

--column 0 

75=>  x"0001",			-- Mem[75] = 0001
76 => x"0001",			-- Mem[76] = 0001
77 => x"0001",			-- Mem[77] = 0001
78 => x"0001",			-- Mem[78] = 0001
79 => x"0001",			-- Mem[79] = 0001

--column 1

80 => x"0001",			-- Mem[80] = 0001
81 => x"0001",			-- Mem[81] = 0001
82 => x"0001",			-- Mem[82] = 0001
83 => x"0001",			-- Mem[83] = 0001
84 => x"0001",			-- Mem[84] = 0001

--column 2

85 => x"0001",			-- Mem[85] = 0001
86 => x"0001",			-- Mem[86] = 0001
87 => x"0001",			-- Mem[87] = 0001
88 => x"0001",			-- Mem[88] = 0001
89 => x"0001",			-- Mem[89] = 0001

--column 3

90 => x"0001",			-- Mem[90] = 0001
91 => x"0001",			-- Mem[91] = 0001
92 => x"0001",			-- Mem[92] = 0001
93 => x"0001",			-- Mem[93] = 0001
94 => x"0001",			-- Mem[94] = 0001

--column 4

95 => x"0001",			-- Mem[95] = 0001
96 => x"0001",			-- Mem[96] = 0001
97 => x"0001",			-- Mem[97] = 0001
98 => x"0001",			-- Mem[98] = 0001
99 => x"0001",			-- Mem[99] = 0001





