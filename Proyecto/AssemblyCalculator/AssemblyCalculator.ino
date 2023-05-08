#include<Arduino.h>
#include <Keypad.h>
#include <LiquidCrystal_I2C.h>

extern "C"
{
  int add(int a, int b);
  int addNegative(int a, int b);
  int subtract(int a, int b);
  int multiply(int a, int b);
  int divide(int a, int b);
}


//inicializar teclado
const byte ROWS = 4;
const byte COLS = 4;

char keys[ROWS][COLS] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'}
};
byte rowPins[ROWS] = {9, 8, 7, 6};
byte colPins[COLS] = {5, 4, 3, 2};

// Inicializa el teclado
Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS); 

// Inicializa LCD
LiquidCrystal_I2C lcd(0x27, 16, 2); 

//Variables
char key;//guardar simbolo de operacion
bool numChange = false;//cuando generar segundo numero
bool isn1Negative = false;//determinar si son negativos
bool isn2Negative = false;
int numero1 = 0;//numeros para operaciones
int numero2 = 0;
int digitosIngresados = 0;//eje x de cada char el el lcd
int numeroRes = 0;//guardar respuesta

//ver menu de opciones
void showOptions(){
  lcd.clear();
  lcd.print("A = +, B = -");
  lcd.setCursor(0,1);
  lcd.print("* = *, # = /");
  delay(5000);
  lcd.clear();
}



//empezar de nuevo con otra operacion
void restart(){
  key = '\0';
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Calculadora");
  numChange = false;
  isn1Negative = false;
  numero1 = 0;
  numero2 = 0;
  digitosIngresados = 0;
  lcd.setCursor(0,1);
}

            
//colocar en pantalla el simbolo de la operacion
void showKey(char character){
  lcd.print(character);
  numChange = true; 
  digitosIngresados++;
}

//funcion para mostrar resultados el lcd
void showResult(int n){
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Resultado: ");
  lcd.setCursor(0, 1);
  lcd.print(n);
  numChange = false;
  numero1 = numeroRes;
  numeroRes = 0;
  numero2 = 0;
  digitosIngresados = String(numero1).length();
  isn1Negative = false;
  isn2Negative = false;
} 

          
void setup() {
  lcd.setCursor(0,0);
  lcd.init(); // Inicializa la pantalla LCD I2C
  lcd.backlight(); // Enciende el backlight de la pantalla LCD I2C
  lcd.print("CALCULADORA..."); // Muestra el mensaje en la pantalla LCD I2C
  delay(2000);
  showOptions();
}

void loop() {
  while (true) {//loop para recibir los dos numeros
    char tecla = keypad.getKey(); // Lee la tecla presionada en el teclado
    //colocar accion de cada tecla no numerica
    if(tecla == 'A' && !numChange){
      //Suma
      key = '+';
      showKey(key);
    }else if(tecla == 'B' && !numChange && numero1 != 0){
      //Resta
      key = '-';
      showKey(key);
      
    }else if(tecla == '*' && !numChange){
      //Multiplicacion
      key = '*';
      showKey(key);
    }else if(tecla == '#' && !numChange){
      //Division
      key = '/';
      showKey(key);
    }
    if(tecla == 'D'){
      //continuar al resultado
      break;
    }
    if(tecla == 'C'){
      //ingresar otro valor
      restart();
    }
    
    //Numeros negativos
    if(numero1 == 0 && tecla == 'B'){
      digitosIngresados++;
      lcd.setCursor(0,1);
      isn1Negative = true;
      lcd.print('-');
    }
    if(numero2 == 0 && tecla == 'B' && numChange){
      if(!(key == '-')){
        lcd.setCursor(digitosIngresados,1);
        digitosIngresados++;
        isn2Negative = true;
        lcd.print('-');
      }
    }
    
    
	//armar numeros
    if (tecla != NO_KEY && isdigit(tecla) ) { // Verifica si se ha presionado una tecla numérica
      lcd.setCursor(digitosIngresados, 1);
      lcd.print(tecla);
      if(!numChange){//armar numero 1
        numero1 = numero1 * 10 + (tecla - '0'); // Agrega el dígito al número
      }else{//armar numero 2
        numero2 = numero2 * 10 + (tecla - '0'); // Agrega el dígito al número
      }
      digitosIngresados++;
    }
    
    
   
    
  }
  //hacer el numero negativo
  if(isn1Negative){
    numero1 = numero1 *(-1);
  }
  if(isn2Negative){
    numero2 = numero2 *(-1);
  }
  
  //hacer operaciones
  switch(key){
    case '+':
    	//suma
      if(numero1<0 && ((numero1 * (-1)) < numero2)){
        numeroRes = addNegative(numero2, numero1);
      }else{
        numeroRes = add(numero1, numero2);
      }
    	break;
    case '-':
    	//resta
      if(numero1>0 && numero1<(numero2)){
        numeroRes = subtract(numero2, numero1);
        numeroRes = numeroRes*(-1);

      }else{
        numeroRes = subtract(numero1, numero2);
      }
      
    	break;
    case '*':
    	if(numero1<0 && numero2>0){
        numero1 = numero1 * (-1);
        numeroRes = multiply(numero1, numero2);
        numeroRes= numeroRes * (-1);        
      }
      else if(numero2<0 && numero1>0){
        numero2 = numero2 * (-1);
        numeroRes = multiply(numero1, numero2);  
        numeroRes= numeroRes * (-1);    
      }
      else if(numero1<0 && numero2<0){
        numero1 = numero1 *(-1);
        numero2 = numero2*(-1);
        numeroRes = multiply(numero1, numero2);    
      }else{
        numeroRes = multiply(numero1, numero2);    
      }
    	break;
    case '/':
    	//division
      if(numero1<0 && numero2>0){
        numero1 = numero1 * (-1);
        numeroRes = divide(numero1, numero2);
        numeroRes= numeroRes * (-1);        
      }
      else if(numero2<0 && numero1>0){
        numero2 = numero2 * (-1);
        numeroRes = divide(numero1, numero2);  
        numeroRes= numeroRes * (-1);    
      }
      else if(numero1<0 && numero2<0){
        numero1 = numero1 *(-1);
        numero2 = numero2*(-1);
        numeroRes = divide(numero1, numero2);    
      }else{
        numeroRes = divide(numero1, numero2);    
      }
    	break;
  }
  
  //presentar resultados
  showResult(numeroRes);  
}

