//*********************************************************
//GLFONT.CPP -- glFont routines
//Copyright (c) 1998 Brad Fish
//Copyright (c) 2002 Henri Kyrki
//See glFont.txt for terms of use
//10.5 2002
//*********************************************************

//#include <stdio.h>
#include "glfont.h"

//*********************************************************
//GLFontBase
//*********************************************************

GLFontBase::GLFontBase() : ok(FALSE)
{
}

void GLFontBase::CreateImpl(const string &Filename, GLuint Tex, bool PixelPerfect)
{
	Font.Char = NULL;
	FreeResources();

	FILE *Input;

	//Open font file
	if ((Input = fopen(Filename.c_str(), "rb")) == NULL)
		throw GLFontError::InvalidFile();

	//Read glFont structure
	fread(&Font, sizeof(GLFONT) - sizeof(GLFONTCHAR*), 1, Input);

	//Save texture number
	Font.Tex = Tex;

	//Get number of characters
	int Num = Font.IntEnd - Font.IntStart + 1;

	//Allocate memory for characters
	//if ((Font.Char = (GLFONTCHAR *)malloc(sizeof(GLFONTCHAR) * Num)) == NULL)
	Font.Char = new GLFONTCHAR[Num];

	//Read glFont characters
	fread(Font.Char, sizeof(GLFONTCHAR), Num, Input);
    
    float temp;
    for(int a = 0; a < Num; a++){
        //Flip y values of tex coords, since texture is upside down
        temp = Font.Char[a].ty1;
        Font.Char[a].ty1 = 1 - Font.Char[a].ty2;
        Font.Char[a].ty2 = 1 - temp;
    
        //Reduce dy to 1; maintain ratio with dx
        Font.Char[a].dx /= Font.Char[a].dy;
        Font.Char[a].dy = 1;
        }

	//Get texture size
	Num = Font.TexWidth * Font.TexHeight * 2;

	//Allocate memory for texture data
	//TexBytes = (char *)malloc(Num)
	char *TexBytes = new char[Num];

	//Read texture data
	fread(TexBytes, sizeof(char), Num, Input);
    
    //Set texture attributes
	glBindTexture(GL_TEXTURE_2D, Font.Tex);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	if(PixelPerfect)
	{
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	}
	else
	{
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	}
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

	//Create texture
	glTexImage2D(GL_TEXTURE_2D, 0, 2, Font.TexWidth, Font.TexHeight, 0, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, (void *)TexBytes);

	//Clean up

	delete []TexBytes;
	fclose(Input);

	ok = TRUE;
}
//*********************************************************
void GLFontBase::FreeResources ()
{
	//Free character memory
	if (Font.Char != NULL) delete []Font.Char;
	ok = FALSE;
}
//*********************************************************
void GLFontBase::Begin ()
{
	if (!ok)
	{
		throw GLFontError::InvalidFont();
	}

	glBindTexture(GL_TEXTURE_2D, Font.Tex);
}
//*********************************************************
GLFontBase::~GLFontBase ()
{
	FreeResources();
}

//*********************************************************
//PixelPerfectGLFont
//*********************************************************

PixelPerfectGLFont::PixelPerfectGLFont()
{
}
//*********************************************************
void PixelPerfectGLFont::Create(const string &Filename, GLuint Tex)
{
	GLFontBase::CreateImpl(Filename, Tex, TRUE);
	for (int i = 0; i < Font.IntEnd - Font.IntStart + 1; i++)
	{
		Font.Char[i].width = (int)((Font.Char[i].tx2 - Font.Char[i].tx1)*Font.TexWidth);
		Font.Char[i].height = (int)((Font.Char[i].ty2 - Font.Char[i].ty1)*Font.TexHeight);
	}
}
//*********************************************************
void PixelPerfectGLFont::TextOut (string String, int x, int y, int z)
{
	//Return if we don't have a valid glFont
	if (!ok)
	{
		throw GLFontError::InvalidFont();
	}

	//Get length of string
	int Length = String.length();

	//Begin rendering quads
	glBegin(GL_QUADS);

	//Loop through characters
	for (int i = 0; i < Length; i++)
	{
		//Get pointer to glFont character
		GLFONTCHAR *Char = &Font.Char[(int)String[i] - Font.IntStart];

		//Specify vertices and texture coordinates
		glTexCoord2f(Char->tx1, Char->ty1);
		glVertex3i(x, y, z);
		glTexCoord2f(Char->tx1, Char->ty2);
		glVertex3i(x, y + Char->height, z);
		glTexCoord2f(Char->tx2, Char->ty2);
		glVertex3i(x + Char->width, y + Char->height, z);
		glTexCoord2f(Char->tx2, Char->ty1);
		glVertex3i(x + Char->width, y, z);

		//Move to next character
		x += Char->width;
	}

	//Stop rendering quads
	glEnd();
}

//*********************************************************
//GLFont
//*********************************************************

GLFont::GLFont()
{
    vertices = new vertex[maxCharacters * 6];
    texCoords = new vertex[maxCharacters * 6];
}

GLFont::~GLFont()
    {
        delete[] vertices;
        delete[] texCoords;
    }
//*********************************************************
void GLFont::Create(const string &Filename, GLuint Tex)
{
	GLFontBase::CreateImpl(Filename, Tex, FALSE);
    for (int i = 0; i < Font.IntEnd - Font.IntStart + 1; i++)
	{
		Font.Char[i].width = ((Font.Char[i].tx2 - Font.Char[i].tx1)*Font.TexWidth);
		Font.Char[i].height = ((Font.Char[i].ty2 - Font.Char[i].ty1)*Font.TexHeight);
		//Font.Char[i].width /= (float)Font.Char[i].height;
		//Font.Char[i].height = 1;
	}
}
//*********************************************************
void GLFont::TextOut (string String, float x, float y, float z, float size)
{
	//Return if we don't have a valid glFont
	if (!ok)
	{
		throw GLFontError::InvalidFont();
        printf("invalid font!\n");
	}

	//Get length of string
	int Length = String.length();

	//Begin rendering quads
	//glBegin(GL_QUADS);

	int i;
	float w, h;
    
	//Loop through characters
	for (i = 0; i < Length; i++)
	{

        //Debug
        //printf("%c\n", String[i]);
        
        //Get pointer to glFont character
		GLFONTCHAR *Char = &Font.Char[(int)String[i] - Font.IntStart];

		w = Char->width * size / Char->height;// * size;//Char->dx * size;
		h = size;// Char->height;// * size;
//		w = Char->width;
//		h = Char->height;

		//Add bottom left triangle vertices
        vertices[i * 6].x = x;
        vertices[i * 6].y = y;
        vertices[i * 6 + 1].x = x;
        vertices[i * 6 + 1].y = y + h;
        vertices[i * 6 + 2].x = x + w;
        vertices[i * 6 + 2].y = y;

        //Add top right triangle vertices
        vertices[i * 6 + 3].x = x;
        vertices[i * 6 + 3].y = y + h;
        vertices[i * 6 + 4].x = x + w;
        vertices[i * 6 + 4].y = y;
        vertices[i * 6 + 5].x = x + w;
        vertices[i * 6 + 5].y = y + h;
        
        //Add bottom left tex coords
        texCoords[i * 6].x = Char->tx1;
        texCoords[i * 6].y = Char->ty1;
        texCoords[i * 6 + 1].x = Char->tx1;
        texCoords[i * 6 + 1].y = Char->ty2;
        texCoords[i * 6 + 2].x = Char->tx2;
        texCoords[i * 6 + 2].y = Char->ty1;
        
        //Add top right tex coords
        texCoords[i * 6 + 3].x = Char->tx1;
        texCoords[i * 6 + 3].y = Char->ty2;
        texCoords[i * 6 + 4].x = Char->tx2;
        texCoords[i * 6 + 4].y = Char->ty1;
        texCoords[i * 6 + 5].x = Char->tx2;
        texCoords[i * 6 + 5].y = Char->ty2;
      

	//Specify vertices and texture coordinates
		/*glTexCoord2f(Char->tx1 * Font.TexWidth, Char->ty1 * Font.TexHeight);
		glVertex3f(x, y, z);
		glTexCoord2f(Char->tx1 * Font.TexWidth, Char->ty2 * Font.TexHeight);
		glVertex3f(x, y + Char->dy, z);
		glTexCoord2f(Char->tx2 * Font.TexWidth, Char->ty2 * Font.TexHeight);
		glVertex3f(x + Char->dx, y + Char->dy, z);//Users/iamparker/Desktop/iPhone 5.rtf
		glTexCoord2f(Char->tx2 * Font.TexWidth, Char->ty1 * Font.TexHeight);
		glVertex3f(x + Char->dx, y, z);*/

		//Move to next character
	x += w;//Char->dx * size;
	}
    
    //for(int a = 0; a < i * 6; a++){
    //    vertices[a].x = (int)vertices[a].x;
    //    vertices[a].y = (int)vertices[a].y;
    //    }

//	glDisable(GL_BLEND);

    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
    glDrawArrays(GL_TRIANGLES, 0, i * 6);

//	glEnable(GL_BLEND);

	//Stop rendering quads
	//glEnd();
}

//End of file



