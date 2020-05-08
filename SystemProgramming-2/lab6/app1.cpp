#include<stdio.h>
#include <thread>
#include <chrono>

void new_func1(void);

int func1(int a)
{
    for(int i = 0; i < 100; i++)
  {
    std::this_thread::sleep_for(std::chrono::milliseconds(1));
      if(i>a)
        return 1;
    
  }

    return 0;
}

int func2()
{
    for(int i = 0; i < 10; i++)
  {
    std::this_thread::sleep_for(std::chrono::milliseconds(10));
  }
    return 0;
}
int func3()
{
    for(int i = 0; i < 10; i++)
  {
    std::this_thread::sleep_for(std::chrono::milliseconds(10));
  }
    return 0;
}

int main(void)
{
    printf("\n Inside main()\n");

  

    for(int i = 0; i<10 ;i++)
  {
    for(int j=100; j > 0; j--)
    {
      if(func1(i) || func2() || func3()){
        printf("\n Inside if()\n");
        printf("%d",j);
      }
    }
  }

    return 0;
}
