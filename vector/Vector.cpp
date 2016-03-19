#include <boost/algorithm/string/split.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/numeric/ublas/matrix.hpp>
#include <boost/numeric/ublas/io.hpp>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>

#define REFLAT    51.080609
#define REFLONG -114.130981

using namespace boost::algorithm;

typedef std::vector<std::string> ArrayData;

int main (int argc,char** argv){


std::ifstream inFile ("wed242016.gps");
std::string dataline;
std::vector<std::string> data;
matrix<double> transForm (3, 3); //Creates a 3x3 matrix


float x_vect;
float y_vect;
float z_vect;



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
