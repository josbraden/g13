all: g13d pbm2lpbm

FLAGS=$(CXXFLAGS) -DBOOST_LOG_DYN_LINK
LIBS=-lusb-1.0 -lboost_log -lboost_log_setup-mt -lboost_thread -lboost_system-mt -lpthread

release: FLAGS=$(CXXFLAGS) -DBOOST_LOG_DYN_LINK -O3

g13.o: g13.hpp helper.hpp g13.cpp
	g++ $(FLAGS) -c g13.cpp

g13_main.o: g13.hpp helper.hpp g13_main.cpp
	g++ $(FLAGS) -c g13_main.cpp


g13_log.o: g13.hpp helper.hpp g13_log.cpp
	g++ $(FLAGS) -c g13_log.cpp

g13_fonts.o: g13.hpp helper.hpp g13_fonts.cpp
	g++ $(FLAGS) -c g13_fonts.cpp

g13_lcd.o: g13.hpp helper.hpp g13_lcd.cpp
	g++ $(FLAGS) -c g13_lcd.cpp

g13_stick.o: g13.hpp helper.hpp g13_stick.cpp
	g++ $(FLAGS) -c g13_stick.cpp
	
g13_keys.o: g13.hpp helper.hpp g13_keys.cpp
	g++ $(FLAGS) -c g13_keys.cpp

helper.o: helper.hpp helper.cpp
	g++ $(FLAGS) -c helper.cpp

g13d: g13_main.o g13.o g13_log.o g13_fonts.o g13_lcd.o g13_stick.o g13_keys.o helper.o
	g++ -o g13d \
		g13_main.o g13.o g13_log.o g13_fonts.o g13_lcd.o g13_stick.o g13_keys.o helper.o \
	 	-lusb-1.0 -lboost_program_options \
	 	-lboost_log    \
	 	-lboost_system -lpthread

pbm2lpbm: pbm2lpbm.cpp
	g++ -o pbm2lpbm pbm2lpbm.cpp

pbm2lpbmRelease: pbm2lpbm.cpp
	g++ -o pbm2lpbm -O3 pbm2lpbm.cpp

release: g13d pbm2lpbmRelease

package:
	rm -Rf g13-userspace
	mkdir g13-userspace
	cp g13.cc g13.hpp logo.hpp Makefile pbm2lpbm.c g13-userspace
	tar cjf g13-userspace.tbz2 g13-userspace
	rm -Rf g13-userspace

clean: 
	rm -f g13d pbm2lpbm
	rm -f *.o
