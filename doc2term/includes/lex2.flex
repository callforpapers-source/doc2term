%{
#include <stdio.h>
/* 
	Maximum number of terms: 5000000
	Maximum number of characters: 20000000
	NOTE: If you need more than this, just change the following numbers.
*/

char lexer[5000000];
char tokens[20000000];
char ngrams[1000000];
int ngramOfSentences = 0;
int numberOfDocs = 0;
int chr = 0;
int ngram = 5;
int min = 0;
char section = '0';
char includeNumbersDates;
char includeEmailsPhonesUrls;
char includeHostsFiles;
/*
	Add a token to the tokens and count number of sentences
*/
int add(char* label, char* token) {
	strcat(lexer, label);
	strcat(tokens, token);
	strcat(tokens, " ");
	chr += strlen(token)+1;
	if (strcmp(label, "S") != 0) {
		ngramOfSentences++;
	}
}
/*
	Will run at the end of the each document to count number of docs and calculate the ngrams.
*/
void endOfDoc() {
	tokens[chr-1] = '\x00';
	strcat(lexer, "D");
	strcat(tokens, "\n");
	numberOfDocs++;
	char str[7];

	if (ngramOfSentences < ngram) {
		sprintf(str, "%d ", ngramOfSentences);
	} else {
		sprintf(str, "%d ", ngram);

	}
	strcat(ngrams, str);
	ngramOfSentences = 0;
}
/*
	T: TERM
	N: NUM
	S: SENTENCE SEPARATOR
	E: EMAIL
	H: HOST
	P: PHONE NUMBER
	F: FILE
	U: URL
	D: NEW DOCUMENT
	Z: TIME
*/

%}

DIGIT 			[0-9]
WORD 			[A-z]
PHRASE 			[A-z0-9\-\.]+
STOP_PUNCS      ("."|"?"|"!"|";"|"·"|"|"|":"|" - "|"("|")"|"\"")+
PHONE 			\+[0-9]{1,3}(-|\s)[0-9]{9,}
DATE 			[0-9]{2,4}(-|".")[0-9]{1,2}(-|".")[0-9]{1,2}
TERM			({WORD}|{DIGIT})*{WORD}({WORD}|{DIGIT}|(('|`)({WORD})))*
SYMBOL 			({WORD}|{DIGIT})({WORD}|{DIGIT}|_|-)*
DOMAIN 			("mil"|"info"|"gov"|"edu"|"biz"|"com"|"org"|"net"|"arpa"|[A-z]{2})
BASEURL 		[A-z0-9][A-z0-9\-\.]*"."{DOMAIN}
URL_PATH 		([!*'();:@&=+$,/?%#_.~]|"-"|"["|"]"|[A-z]|[0-9])+

%%

\n 		{
			endOfDoc("D", "\n");
		}
(" "|"\t"|"\r"|"^"|"_")*		{
			/*ignore*/
		}
("-"|"+"){0,1}{DIGIT}+([":"|"."|"-"|"_"]{DIGIT}+)*		{
			if (includeNumbersDates == '1') {
				add("N", yytext);
			}
		}
({WORD}"."({WORD}".")+)|({TERM}("&"{TERM})+) 	{
			add("T", yytext);
		}
{STOP_PUNCS}	{
			if (ngramOfSentences != 0) {
				add("S", ".");
			}
		}
{PHONE} {
			if (includeEmailsPhonesUrls == '1') {
				add("P", yytext);
			}
		}
{DATE} {
			if (includeNumbersDates == '1') {
				add("Z", yytext);
			}
		}
{TERM}("-"{TERM})+ {
			add("T", yytext);
			
		}
{TERM}("_"{TERM})+ {
			add("T", yytext);
			
		}
{TERM}("'"|"`"{WORD}{1,2}) {
			add("T", yytext);
		}
{TERM}"s"("'"|"`") {
			add("T", yytext);
		}
{TERM}  {
			add("T", yytext);
		}
("mailto:")?{PHRASE}("."{PHRASE})*"@"{PHRASE}"."{DOMAIN} {
			if (includeEmailsPhonesUrls == '1') {
				add("E", yytext);
			}
		}
{BASEURL} {
			if (includeHostsFiles == '1') {
				add("H", yytext);
			}
		}
{SYMBOL}("."{SYMBOL})*("."{SYMBOL}) {
			if (includeHostsFiles == '1') {
				add("F", yytext);
			}
		}
({WORD}+"://"){BASEURL}{URL_PATH}? {
			if (includeEmailsPhonesUrls == '1') {
				add("U", yytext);
			}
		}
{STOP_PUNCS}[^A-z0-9\-_]+{STOP_PUNCS}	{
			if (ngramOfSentences != 0) {
				add("S", ".");
			}
		}
.   				{/*ignore*/}
"&"[A-z0-9#]+";" 	{/*ignore html entities*/}
(","|"'"|"`"|"-")+ 	{/*ignore punctuations. if you don't like to delete these punctuations, just add it: add("O", yytext);*/}
%%
 
int yywrap()
{
	return 1;
}

int main(int argc, char* argv[])
{
	if(argc == 0)
	{
		return 0;
	}
	if (argv[3]) {
		includeNumbersDates = argv[3][1];
		includeEmailsPhonesUrls = argv[3][2];
		includeHostsFiles = argv[3][3];
	}
	FILE *fp = fopen(argv[1], "r");
	FILE *fpw;
	if(fp) {
		yyin = fp;
		yylex();
		fclose(fp);
	} else {
		return 0;
	}
	if (argv[2]) {
		fpw = fopen(argv[2], "w");
	} else {
		fpw = fopen("tokenize-outcome.txt", "w");
	}
	if (argv[3]) {
		section = argv[3][0];
	}
	if (section=='0' || section=='1') {
		fprintf(fpw, "%s\n", lexer);
	}
	if (section=='0' || section=='2') {
		if (section=='0') {
			fprintf(fpw, "$$tokens$$\n");
		}
		fprintf(fpw, "%s", tokens);
	}
	if (section=='0' || section=='3') {
		if (section=='0') {
			fprintf(fpw, "\n$$meta$$\n");

		}
		fprintf(fpw, "%s\n", ngrams);
		fprintf(fpw, "%d", numberOfDocs);
	}
	fclose(fpw);
}
