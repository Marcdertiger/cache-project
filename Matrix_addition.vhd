

-- Addition of two 5x5 matrices

-- addition of two new op codes was implemented : 1. M[Rx] -> Rb  2. Rx>24: PC<-Rb (if register "0R00" > 24, jump to instruction # "00II")


-- matrix addition. result found in memory location mem[70]..mem[94]
		(starts adding from top left corner then goes top-down following the columns)


		
		-- space for loop mem[0..49]
		
0 =>  x"3000",		-- R0 = 0   (Startup value of program counter)
1 =>  x"3150",		-- R1 = 50	 (position of first element of matrix 0)
2 =>  x"3275",		-- R2 = 75	 (position of first element of matrix 1)
3 =>  x"3301",		-- R3 = 1	 (increment by 1)
4 =>  x"3464",		-- R4 = 100	(position of first element of matrix 2 (result matrix))

5=>  x"1145",		-- M[45] <- R0 (M[45] is the position of matrix 0 pointer)				M[45]=50
6=>  x"1246",		-- M[46] <- R1 (M[46] is the position of matrix 1 pointer)				M[46]=75
7=>  x"1047",		-- M[45] <- R0 (M[47] is the program counter, loop exits at 25 runs)	M[47]=0

8=>  x"8160",		-- R6    <- M[R1] (matrix 0 current element copied in R6)
9=>  x"8270",		-- R7    <- M[R2] (matrix 0 current element copied in R7)
10=> x"4678",		-- R8    <- R6 + R7
11=> x"2480",		-- M[R4] <- R8

12=> x"9008",		-- R0<25: PC<- #8


-- output values here















--matrix 0 (columns created from left to right)(items in columnss are created top to bottom)

--column 0 

50 => x"0001",			-- Mem[0] = 0001
51 => x"0001",			-- Mem[1] = 0001
52 => x"0001",			-- Mem[2] = 0001
53 => x"0001",			-- Mem[3] = 0001
54 => x"0001",			-- Mem[4] = 0001

--column 1

55 => x"0001",			-- Mem[5] = 0001
56 => x"0001",			-- Mem[6] = 0001
57 => x"0001",			-- Mem[7] = 0001
58 => x"0001",			-- Mem[8] = 0001
59 => x"0001",			-- Mem[9] = 0001

--column 2

60 => x"0001",			-- Mem[10] = 0001
61 => x"0001",			-- Mem[11] = 0001
62 => x"0001",			-- Mem[12] = 0001
63 => x"0001",			-- Mem[13] = 0001
64 => x"0001",			-- Mem[14] = 0001

--column 3

65 => x"0001",			-- Mem[15] = 0001
66 => x"0001",			-- Mem[16] = 0001
67 => x"0001",			-- Mem[17] = 0001
68 => x"0001",			-- Mem[18] = 0001
69 => x"0001",			-- Mem[19] = 0001

--column 4

70 => x"0001",			-- Mem[20] = 0001
71 => x"0001",			-- Mem[21] = 0001
72 => x"0001",			-- Mem[22] = 0001
73 => x"0001",			-- Mem[23] = 0001
74 => x"0001",			-- Mem[24] = 0001



--matrix 2 (columns created from left to right)(items in colums are created top to bottom)

--column 0 

75=> x"0001",			-- Mem[0] = 0001
76 => x"0001",			-- Mem[1] = 0001
77 => x"0001",			-- Mem[2] = 0001
78 => x"0001",			-- Mem[3] = 0001
79 => x"0001",			-- Mem[4] = 0001

--column 1

80 => x"0001",			-- Mem[5] = 0001
81 => x"0001",			-- Mem[6] = 0001
82 => x"0001",			-- Mem[7] = 0001
83 => x"0001",			-- Mem[8] = 0001
84 => x"0001",			-- Mem[9] = 0001

--column 2

85 => x"0001",			-- Mem[10] = 0001
86 => x"0001",			-- Mem[11] = 0001
87 => x"0001",			-- Mem[12] = 0001
88 => x"0001",			-- Mem[13] = 0001
89 => x"0001",			-- Mem[14] = 0001

--column 3

90 => x"0001",			-- Mem[15] = 0001
91 => x"0001",			-- Mem[16] = 0001
92 => x"0001",			-- Mem[17] = 0001
93 => x"0001",			-- Mem[18] = 0001
94 => x"0001",			-- Mem[19] = 0001

--column 4

95 => x"0001",			-- Mem[20] = 0001
96 => x"0001",			-- Mem[21] = 0001
97 => x"0001",			-- Mem[22] = 0001
98 => x"0001",			-- Mem[23] = 0001
99 => x"0001",			-- Mem[24] = 0001





