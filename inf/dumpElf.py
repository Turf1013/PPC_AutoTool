from src.other.parseDump import parseDump
	
	
if __name__ == "__main__":
	srcFileName = "F:\Qt_prj\hdoj\data.in"
	desFileName = "F:\Qt_prj\hdoj\data.out"
	
	L = parseDump.GenCode(srcFileName)
	parseDump.WriteFile(desFileName, L)
	