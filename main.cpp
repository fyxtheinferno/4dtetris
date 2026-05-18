#include "raylib.h"

int main() {

    const int screenWidth = 640;
    const int screenHeight = 480;


    InitWindow(screenWidth, screenHeight, "4D Tetris");
    Model l_piece = LoadModel("assets/3d_lpiece_test.obj");
    RenderTexture game = LoadRenderTexture(screenWidth, screenHeight);

    Camera camera = { -5,5, 0, 0, 0, 0};

    while (!WindowShouldClose()) {
        
        //reading input

        if(IsKeyDown(KEY_Q)) {

        } else if(IsKeyDown(KEY_W)) {
            
        }

        if(IsKeyDown(KEY_A)) {

        } else if(IsKeyDown(KEY_S)) {
            
        }

        if(IsKeyDown(KEY_Z)) {

        } else if(IsKeyDown(KEY_X)) {
            
        }

        if(IsKeyDown(KEY_E)) {

        } else if(IsKeyDown(KEY_R)) {
            
        }

        if(IsKeyDown(KEY_D)) {

        } else if(IsKeyDown(KEY_F)) {
            
        }

        if(IsKeyDown(KEY_C)) {

        } else if(IsKeyDown(KEY_V)) {
            
        }

        //rendering

        BeginTextureMode(game);

            ClearBackground(GRAY);
            BeginMode3D(camera);

                DrawModel(l_piece, (Vector3){ 0.0f, 0.0f, 0.0f }, 1, WHITE);

            EndMode3D();

        EndTextureMode();

        
    }

    UnloadRenderTexture(game);
    UnloadModel(l_piece);

    CloseWindow();

    return 0;
}