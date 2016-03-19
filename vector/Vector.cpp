#include <boost/algorithm/string/split.hpp>
#include <boost/algorithm/string.hpp>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>

using namespace boost::algorithm;

typedef std::vector<std::string> ArrayData;

int main (int argc,char** argv){


std::ifstream inFile ("wed242016.gps");
std::string dataline;
std::vector<std::string> data;


	if(inFile.is_open()){
		while(getline(inFile,dataline)){

					std::cout << std::endl;

			if(starts_with(dataline,"#BESTXYZA")){

				split(data,dataline,is_any_of(","));

				data.erase(data.begin(),data.begin()+11);

				
				for (ArrayData::size_type i = 0; i < 3; ++i){
					std::cout << data[i] << std::endl;
				}
			
			
					data.clear();
		
					std::cout << std::endl;


			}





		}
		


	}




}
