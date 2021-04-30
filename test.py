from time import sleep


sleep(20)

for i in range(0, 100):
	f = open("./output/test" + str(i) + ".txt", "w")
	f.write("hello")
	sleep(1)
	f.close()
