#include<stdio.h>
#include <thread>
#include <chrono>

int new_func1(int a){
  for(int i = 0; i < 100; i++)
  {
    std::this_thread::sleep_for(std::chrono::milliseconds(1));
      if(i>a)
        return 1;
    
  }
  for(int i = 0; i < 20; i++)
  {
    std::this_thread::sleep_for(std::chrono::milliseconds(10));
  }

    return 0;
};

int main(void)
{
    printf("\n Inside main()\n");

  

    for(int i = 0; i<10 ;i++)
  {
    for(int j=100; j > 0; j--)
    {
      if(new_func1(i)){
        printf("\n Inside if()\n");
        printf("%d",j);
      }
    }
  }

    return 0;
}
