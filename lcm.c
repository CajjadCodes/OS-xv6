#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"


int gcd(int a,int b)
{
	int ans=1;
	for(int i=2;i<=a;i++)
	{
		if(a%i==0 && b%i==0)
		{
			ans=i;
		}
	}
	return ans;
}

int _len(int a)
{
	if (a<10)
		return 1;
	else
		return 1+_len(a/10);
}
void itos(int a,char s[20])
{
	int i=0;
	//char s[20];
	char _s;
	while (a>9)
	{
		//printf(1,"%s\n",s);
		s[i]=a%10+'0';
		a/=10;
		i++;
	}
	s[i]=a+'0';
	//printf(1,"%s %d\n",s,i);
	for (int j=0;j<=i/2;j++)
	{
		_s=s[i-j];
		s[i-j]=s[j];
		s[j]=_s;
	}
	s[i+1]=0;
	//return _s;
}

int file_already_exists(char* filename)
{
	int fd = open(filename, O_RDONLY);
  	if(fd < 0) //checks if it doesn't exist
    	return 0;
	else
	{
		close(fd);
		return 1;
	}
} 

void delete_file(char* filename)
{
	if (unlink(filename) < 0) //remove file
		printf(2, "Couldn't remove previous record");
}

int main(int argc, char const *argv[])
{
	int arr[8];
	int l=1;
	while (argv[l] && l<9)
	{
		arr[l-1]=atoi(argv[l]);
		l=l+1;
	}
	int ans=arr[0];
	for (int i=1;i<8;i++)
	{
		if(arr[i]==0)
			break;
		ans=(ans*arr[i])/gcd(ans,arr[i]);
	}
	char *filename = "lcm_result.txt";
	if (file_already_exists(filename))
		delete_file(filename);
	int f=open(filename, O_CREATE | O_RDWR);
	char _ans[20];
	itos(ans,_ans);
	write(f,_ans,_len(ans));
	write(f,"\n",1);
	close(f);
	//printf(1,"%d %s %d\n",ans,_ans,_len(ans));
	exit();
}