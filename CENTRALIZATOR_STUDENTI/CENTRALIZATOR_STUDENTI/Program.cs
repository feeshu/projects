using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

namespace CENTRALIZATOR_STUDENTI
{
    # region Clasa cu detalii despre o persoana
    public class Persoana
    {
        public string nume, CNP;
        public int varsta;
    }
    #endregion

    # region Clasa cu detalii despre un student
    public class Student : Persoana
    {
        public string facultate, specializare, grupa;
        public float medie;
        public float[] note = new float[6];

        public List<Student> listaStud = new List<Student>();
        public int nrStudenti;

        public int adaugaStud(string numeS, string CNPS, int varstaS, string facultateS, string specializareS, string grupaS, float[] noteS)
        {
            Student student = new Student();

            student.nume = numeS;
            student.CNP = CNPS;
            student.varsta = varstaS;
            student.facultate = facultateS;
            student.specializare = specializareS;
            student.grupa = grupaS;
            student.note = noteS;

            for (int i = 0; i < 6; i++)
                student.medie += student.note[i];

            student.medie = student.medie / 6;

            listaStud.Add(student);

            nrStudenti = listaStud.Count;

            return 1;
        }

        public int adaugaStudFis(string numeS, string CNPS, int varstaS, string facultateS, string specializareS, string grupaS, float nota1, float nota2, float nota3, float nota4, float nota5, float nota6)
        {
            Student student = new Student();

            student.nume = numeS;
            student.CNP = CNPS;
            student.varsta = varstaS;
            student.facultate = facultateS;
            student.specializare = specializareS;
            student.grupa = grupaS;
            student.note[0] = nota1;
            student.note[1] = nota2;
            student.note[2] = nota3;
            student.note[3] = nota4;
            student.note[4] = nota5;
            student.note[5] = nota6;


            for (int i = 0; i < 6; i++)
                student.medie += student.note[i];

            student.medie = student.medie / 6;

            listaStud.Add(student);

            nrStudenti = listaStud.Count;

            return 1;
        }
    #endregion
    }

    class Program
    {
        static public Student studenti = new Student();
        # region Metoda de afisare a studentilor
        static public void AfisareStudenti()
        {
            Console.WriteLine("_____________________________________________________________________________________________________________________________________________________________________________________");
            Console.WriteLine("Nr.           Nume                      CNP      Varsta              Facultate                         Specializare                   Grupa     ENG  POO  SQL JAVA  C++ SPORT  Media");
            Console.WriteLine("_____________________________________________________________________________________________________________________________________________________________________________________");

            for (int i = 0; i < studenti.nrStudenti; i++)
            {
                Console.Write("{0, -5}", i + 1);
                Console.Write("{0, -30}", studenti.listaStud[i].nume);
                Console.Write("{0, -16}", studenti.listaStud[i].CNP);
                Console.Write("{0, -6}", studenti.listaStud[i].varsta);
                Console.Write("{0, -35}", studenti.listaStud[i].facultate);
                Console.Write("{0, -43}", studenti.listaStud[i].specializare);
                Console.Write("{0, -9}", studenti.listaStud[i].grupa);
                Console.Write("{0, -5}", studenti.listaStud[i].note[0]);
                Console.Write("{0, -5}", studenti.listaStud[i].note[1]);
                Console.Write("{0, -5}", studenti.listaStud[i].note[2]);
                Console.Write("{0, -5}", studenti.listaStud[i].note[3]);
                Console.Write("{0, -5}", studenti.listaStud[i].note[4]);
                Console.Write("{0, -5}", studenti.listaStud[i].note[5]);
                Console.Write("{0, -6}", studenti.listaStud[i].medie);
                Console.WriteLine();
            }
            Console.WriteLine("_____________________________________________________________________________________________________________________________________________________________________________________");
        }


        #endregion

        static public void StudentNou()
        {
            string nume, CNP, facultate, specializare, grupa;
            int varsta;
            float[] note = new float[6];
            
            Console.Write("Nume: ");
            nume = Console.ReadLine();

            Console.Write("CNP: ");
            CNP = Console.ReadLine();

            Console.Write("Varsta: ");
            varsta = Convert.ToInt32(Console.ReadLine());

            Console.Write("Facultate: ");
            facultate = Console.ReadLine();

            Console.Write("Specializare: ");
            specializare = Console.ReadLine();

            Console.Write("Grupa: ");
            grupa = Console.ReadLine();
    

            for(int i=1; i<=6; i++)
            {
                Console.Write("Cursul nr. " + i.ToString() + " - Nota: ");
                note[i-1] = Convert.ToSingle(Console.ReadLine());
        
            }
    
            studenti.adaugaStud(nume, CNP, varsta, facultate, specializare, grupa, note);
        

        }

        static public void AfisareMedie()
        {

            
            string[] listaGrupe = new string[studenti.nrStudenti];
            

            for (int i = 0; i < studenti.nrStudenti; i++)
                listaGrupe[i] = studenti.listaStud[i].grupa;

            string[] listaUnica = listaGrupe.Distinct().ToArray();


            float[] medietot = new float[listaUnica.Length];
            int[] match = new int[listaUnica.Length];
           
            for (int j = 0; j < listaUnica.Length; j++)
            {
                for (int i = 0; i < studenti.nrStudenti; i++)
                {
                    if (studenti.listaStud[i].grupa == listaUnica[j])
                    {
                        match[j]++; 
                        medietot[j] += studenti.listaStud[i].medie;
                    }        
                }
                medietot[j] /= match[j];
                
            }

            Console.WriteLine("\n__________________________________");

            for(int i = 0; i < listaUnica.Length; i++)
                Console.WriteLine("\nMedia grupei\t" + listaUnica[i] + "\t: " + medietot[i]); 

            Console.WriteLine("____________________________________\n\n");     
                
        }

        static void Main(string[] args)
        {
            int input = 0;
            int indexFisier = 0;
            int x = 1;
            int latime = Console.WindowWidth;
            int inaltime = Console.WindowHeight;
            int latimeNoua = latime + 120;
            int inaltimeNoua = inaltime + 10;

            Console.SetWindowSize(latimeNoua, inaltimeNoua);

            Console.WriteLine("Centralizator Studenti pentru Gigel");
            Console.WriteLine("___________________________________\n");

            while(true)
            {
                Console.WriteLine("\nAlegeti o optiune:");
                Console.WriteLine("1. Citire de la tastatura");
                Console.WriteLine("2. Citire din fisier");
                Console.WriteLine("3. Afisare centralizator");
                Console.WriteLine("4. Afisare studenti in functie de grupa.");
                Console.WriteLine("5. Afisare medie generala grupe.");
                Console.WriteLine("6. Iesire\n");

                int alegere = int.Parse(Console.ReadLine());
                Console.Clear();

                switch(alegere)
                {
                    case 1:
                        Console.Write("Numarul de studenti ce vor fi adaugati: ");
                        int nrStud = Convert.ToInt32(Console.ReadLine());

                        for(int i=1; i<=nrStud; i++)
                        {
                            Console.WriteLine("\n Studentul nr. " + i.ToString());
                            StudentNou();
                        }
                        Console.Clear();
                        break;
                 
                    case 2:
                     
	                    Console.ForegroundColor = ConsoleColor.Red;
                        Console.WriteLine("(!) Se va adauga cate un camp pe fiecare linie, fara randuri libere. (!)");
                        Console.WriteLine("(!) Fisierul va fi citit din bin/Debug/ (!)");
                        Console.ResetColor();
                        Console.WriteLine("Exemplu de fisier: studenti.txt");

                        Console.WriteLine("\nNumele fisierului (+extensie):");
                        string path = Console.ReadLine();

                        float[] note = new float[6];
                        string[] linii = System.IO.File.ReadAllLines(@path);

                        for (int i = 1; i <= linii.Length / 12; i++)
                            {
                                int j = indexFisier;

                                note[x - 1] = Convert.ToSingle(linii[j + 6]);
                                note[x] = Convert.ToSingle(linii[j + 7]);
                                note[x + 1] = Convert.ToSingle(linii[j + 8]);
                                note[x + 2] = Convert.ToSingle(linii[j + 9]);
                                note[x + 3] = Convert.ToSingle(linii[j + 10]);
                                note[x + 4] = Convert.ToSingle(linii[j + 11]);

                                studenti.adaugaStudFis(linii[j], linii[j+1], Convert.ToInt32(linii[j+2]), linii[j+3],linii[j+4], linii[j+5], note[0], note[1], note[2], note[3], note[4], note[5]);
                                indexFisier += 12;

                            }
                        
                        indexFisier = 0;
                        Console.WriteLine("\n\nDatele au fost citite.\n");
                        Console.WriteLine("Apasati un buton pentru a continua...\n");
                        Console.ReadLine();
                        Console.Clear();
                        break;

                    case 3:
                        Console.Clear();
                        AfisareStudenti();
                        
                        Console.WriteLine("\n\nApasati un buton pentru a continua...");
                        Console.ReadLine();

                        Console.Clear();
                        break;

                    case 4:
                        Console.WriteLine("Introduceti grupa: ");
                        string grupa = Console.ReadLine();

                         Console.WriteLine("_____________________________________________________________________________________________________________________________________________________________________________________");
                         Console.WriteLine("Nr.           Nume                      CNP      Varsta              Facultate                         Specializare                   Grupa     ENG  POO  SQL JAVA  C++ SPORT  Media");
                         Console.WriteLine("_____________________________________________________________________________________________________________________________________________________________________________________");

                        for (int i = 0; i < studenti.nrStudenti; i++)
                        {
                            if(studenti.listaStud[i].grupa == grupa)
                            {
                                Console.Write("{0, -5}", i + 1);
                                Console.Write("{0, -30}", studenti.listaStud[i].nume);
                                Console.Write("{0, -16}", studenti.listaStud[i].CNP);
                                Console.Write("{0, -6}", studenti.listaStud[i].varsta);
                                Console.Write("{0, -35}", studenti.listaStud[i].facultate);
                                Console.Write("{0, -43}", studenti.listaStud[i].specializare);
                                Console.Write("{0, -9}", studenti.listaStud[i].grupa);
                                Console.Write("{0, -5}", studenti.listaStud[i].note[0]);
                                Console.Write("{0, -5}", studenti.listaStud[i].note[1]);
                                Console.Write("{0, -5}", studenti.listaStud[i].note[2]);
                                Console.Write("{0, -5}", studenti.listaStud[i].note[3]);
                                Console.Write("{0, -5}", studenti.listaStud[i].note[4]);
                                Console.Write("{0, -5}", studenti.listaStud[i].note[5]);
                                Console.Write("{0, -6}", studenti.listaStud[i].medie);
                                Console.WriteLine();
                            }
                        }
                        Console.WriteLine("_____________________________________________________________________________________________________________________________________________________________________________________");

                        Console.WriteLine("\n\nApasati un buton pentru a continua...");
                        Console.ReadLine();
                        Console.Clear();
                        break;

                    case 5:
                        AfisareMedie();
                        
                        Console.WriteLine("Apasati un buton pentru a continua...");
                        Console.ReadLine();
                        Console.Clear();
                        break;
                    case 6:
                        input = 60;
                        break;
                }
                
                input++;
                if (input < 60)
                    continue;
                else
                    break;
            }           

 

            char a = Console.ReadKey().KeyChar;            
        }
    }
}
