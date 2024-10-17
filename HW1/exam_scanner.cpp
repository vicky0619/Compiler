#include <iostream>

using namespace std;

string int_tmp="",texts="",tmp="",ans="";
char input;
bool hasint = false;
bool hasid = false;
bool correct = true;

bool isnum( char c)
{
    return((c>='1' && c<='9'));
}
bool isnums(char c)
{
    return((c>='0' && c<='9'));
}
bool isop(char c)
{
    return(c=='+' || c=='-' || c=='*' || c=='/' || c=='=');
}
bool id(char c)
{
    return (c>='A' && c<='Z' || c>='a' && c<='z');
}
bool ids(char c)
{
    return ( c>='A' && c<='Z' || c>='a' && c<='z');
}

void determine_int()
{
    if(hasid)
    {
        //cout<<"wrong deint"<<endl;
        correct = false;
    }
	else if(hasint)
	{
        //cout<<"go here"<<endl;
	    ans+=int_tmp;
        ans+="\n";
		int_tmp="";
		hasint=false;
	}
}

void determine_int_int(int i)
{
    if(hasid)
    {
        //cout<<"wrong deint_int"<<endl;
        correct = false;
    }
	else if(!hasint)
	{
		ans+="NUM ";
		hasint=true;
	}
	int_tmp+=texts[i];
}

void determine_id(int i)
{
    if(hasint)
    {
        correct = false;
        // if(!isop(texts[i-1]))
        // {
        //     //cout<<"wrong_deid"<<endl;
            
        // }
    }
	else if(hasid)
	{
	    ans+=tmp;
        ans+="\n";
		tmp="";
		hasid=false;
	}
}

void determine_id_id(int i)
{
	if(hasint)
    {
        cout<<"wrong de_id_id"<<endl;
        correct = false;
    }
    else if(!hasid)
	{
		ans+="ID ";
		hasid=true;
	}
	tmp+=texts[i];
}
int main() {
	while(scanf("%c",&input)!=EOF) texts+=input;
    //cout<<texts<<endl;
    
    //cout<<texts;
    int i=0,j=texts.length();
	while(i<j)
    {
        //cout<<"i="<<i<<" "<<texts[i]<<endl;
        //cout<<ans<<endl;
        //cout<<ans;
        //cout<<"i="<<i<<endl;
        //cout<<texts[i]<<endl;
        if(id(texts[i]))
        {
            determine_id_id(i);
            //cout<<ans<<endl;
            i++;
            //cout<<i<<endl;
            while(ids(texts[i]))
            {
                determine_id_id(i);
                //cout<<texts[i];
                i++;
            }
            i--;
            determine_id(i);
        }
        else if(texts[i]=='(')
        {
            determine_id(i);
            determine_int();
    		ans+="LPR \n";
        }
        else if(texts[i]==')')
        {
            //cout<<"here"<<endl;
            determine_id(i);
            determine_int();
            ans+="RPR \n";
            //cout<<ans;
        }
        else if(texts[i]=='-')
        {
            if(!isnum(texts[i+1]))
            {
                ans+="OP -\n";
            }
            else{
                determine_int();
                determine_int_int(i);
            }
            
        }
        else if(isnum(texts[i]))
        {
            determine_int_int(i);  
            i++;
            //cout<<i<<endl;
            while(isnums(texts[i]))
            {
                determine_int_int(i);
                //cout<<texts[i];
                i++;
            }
            i--;
            determine_int();  
        }
        else if(isop(texts[i]))
        {
            determine_int();
            ans+="OP ";
            ans+=texts[i];
            ans+="\n";
        }
        else if(texts[i]==' ')
        {
            determine_id(i);
            determine_int();
        }
        else if(texts[i]!='\n')
        {
            //cout<<"wrong else"<<endl;
            correct = false;
        }
        i++;
    }
    if(correct)
    {
        //cout<<endl;
        cout<<ans;
        if(hasid) cout<<tmp<<endl;
        else if(hasint) cout<<int_tmp<<endl;
    }
    else{
        cout<<"invalid output"<<endl;
    }
}