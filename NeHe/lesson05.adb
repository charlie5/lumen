--
-- Copyright (c) 2011 Julian Leyh <julian@vgai.de>
--
-- Permission to use, copy, modify, and distribute this software for any
-- purpose with or without fee is hereby granted, provided that the above
-- copyright notice and this permission notice appear in all copies.
--
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-- WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-- MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-- ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-- WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-- ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-- OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--

with Ada.Characters.Latin_1;
with Lumen.Window;
with Lumen.Events.Animate;
with Lumen.GL;
with Lumen.GLU;

procedure Lesson05 is

   The_Window : Lumen.Window.Handle;
   Framerate : constant := 24;

   Triangle_Rotation : Float := 0.0;
   Quad_Rotation     : Float := 0.0;

   Program_Exit : Exception;

   -- simply exit this program
   procedure Quit_Handler (Event : in Lumen.Events.Event_Data) is
   begin
      raise Program_Exit;
   end;

   -- Resize the scene
   procedure Resize_Scene (Width, Height : in Natural) is
      use Lumen.GL;
      use Lumen.GLU;
   begin
      -- reset current viewport
      Viewport (0, 0, Width, Height);

      -- select projection matrix and reset it
      MatrixMode (GL_PROJECTION);
      LoadIdentity;

      -- calculate aspect ratio
      Perspective (45.0, Long_Float (Width) / Long_Float (Height), 0.1, 100.0);

      -- select modelview matrix and reset it
      MatrixMode (GL_MODELVIEW);
   end Resize_Scene;

   procedure Init_GL is
      use Lumen.GL;
      use Lumen.GLU;
   begin
      -- smooth shading
      ShadeModel (GL_SMOOTH);

      -- black background
      ClearColor (0.0, 0.0, 0.0, 0.0);

      -- depth buffer setup
      ClearDepth (1.0);
      -- type of depth test
      DepthFunc (GL_LESS);
      -- enable depth testing
      Enable (GL_DEPTH_TEST);
      Enable (GL_CULL_FACE);

      Hint (GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
   end Init_GL;

   -- Resize and Initialize the GL window
   procedure Resize_Handler (Event : in Lumen.Events.Event_Data) is
      Height : Natural := Event.Resize_Data.Height;
      Width  : constant Natural := Event.Resize_Data.Width;
   begin
      -- prevent div by zero
      if Height = 0 then
         Height := 1;
      end if;

      Resize_Scene (Width, Height);
   end;

   procedure Draw is
      use Lumen.GL;
      use type Bitfield;
   begin
      -- clear screen and depth buffer
      Clear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
      -- reset current modelview matrix
      LoadIdentity;
      -- move to the left half of the screen
      Translate (Float (-1.5), 0.0, -6.0);
      -- rotate the Triangle
      Rotate (Triangle_Rotation, 0.0, 1.0, 0.0);
      -- draw triangle
      glBegin (GL_TRIANGLES);
      begin
         -- front
         Color (Float (1.0), 0.0, 0.0); -- red
         Vertex (Float ( 0.0),  1.0, 0.0); -- top (front)
         Color (Float (0.0), 1.0, 0.0); -- green
         Vertex (Float (-1.0), -1.0, 1.0); -- left (front)
         Color (Float (0.0), 0.0, 1.0); -- blue
         Vertex (Float ( 1.0), -1.0, 1.0); -- right (front)
         -- right
         Color (Float (1.0), 0.0, 0.0); -- red
         Vertex (Float ( 0.0),  1.0, 0.0); -- top (right)
         Color (Float (0.0), 0.0, 1.0); -- blue
         Vertex (Float ( 1.0), -1.0, 1.0); -- left (right)
         Color (Float (0.0), 1.0, 0.0); -- green
         Vertex (Float ( 1.0), -1.0, -1.0); -- right (right)
         -- back
         Color (Float (1.0), 0.0, 0.0); -- red
         Vertex (Float ( 0.0),  1.0, 0.0); -- top (back)
         Color (Float (0.0), 1.0, 0.0); -- green
         Vertex (Float ( 1.0), -1.0, -1.0); -- left (back)
         Color (Float (0.0), 0.0, 1.0); -- blue
         Vertex (Float (-1.0), -1.0, -1.0); -- right (back)
         -- left
         Color (Float (1.0), 0.0, 0.0); -- red
         Vertex (Float ( 0.0),  1.0, 0.0); -- top (left)
         Color (Float (0.0), 0.0, 1.0); -- blue
         Vertex (Float (-1.0), -1.0, -1.0); -- left (left)
         Color (Float (0.0), 1.0, 0.0); -- green
         Vertex (Float (-1.0), -1.0, 1.0); -- right (left)
      end;
      glEnd;

      -- reset current modelview matrix
      LoadIdentity;
      -- move to the right half of the screen
      Translate (Float (1.5), 0.0, -7.0);
      -- rotate the Quad
      Rotate (Quad_Rotation, 1.0, 1.0, 1.0);
      -- draw square
      glBegin (GL_QUADS);
      begin
         -- top
         Color (Float (0.0), 1.0, 0.0);
         Vertex (Float ( 1.0),  1.0, -1.0);
         Vertex (Float (-1.0),  1.0, -1.0);
         Vertex (Float (-1.0),  1.0,  1.0);
         Vertex (Float ( 1.0),  1.0,  1.0);
         -- bottom
         Color (Float (1.0), 0.5, 0.0);
         Vertex (Float ( 1.0), -1.0,  1.0);
         Vertex (Float (-1.0), -1.0,  1.0);
         Vertex (Float (-1.0), -1.0, -1.0);
         Vertex (Float ( 1.0), -1.0, -1.0);
         -- front
         Color (Float (1.0), 0.0, 0.0);
         Vertex (Float ( 1.0),  1.0,  1.0);
         Vertex (Float (-1.0),  1.0,  1.0);
         Vertex (Float (-1.0), -1.0,  1.0);
         Vertex (Float ( 1.0), -1.0,  1.0);
         -- back
         Color (Float (1.0), 1.0, 0.0);
         Vertex (Float ( 1.0), -1.0, -1.0);
         Vertex (Float (-1.0), -1.0, -1.0);
         Vertex (Float (-1.0),  1.0, -1.0);
         Vertex (Float ( 1.0),  1.0, -1.0);
         -- left
         Color (Float (0.0), 0.0, 1.0);
         Vertex (Float (-1.0),  1.0,  1.0);
         Vertex (Float (-1.0),  1.0, -1.0);
         Vertex (Float (-1.0), -1.0, -1.0);
         Vertex (Float (-1.0), -1.0,  1.0);
         -- right
         Color (Float (1.0), 0.0, 1.0);
         Vertex (Float ( 1.0),  1.0, -1.0);
         Vertex (Float ( 1.0),  1.0,  1.0);
         Vertex (Float ( 1.0), -1.0,  1.0);
         Vertex (Float ( 1.0), -1.0, -1.0);
      end;
      glEnd;

      Triangle_Rotation := Triangle_Rotation + 10.0;
      Quad_Rotation := Quad_Rotation - 7.5;
   end Draw;

   procedure Frame_Handler (Frame_Delta : in Duration) is
      pragma Unreferenced (Frame_Delta);
   begin
      Draw;
      Lumen.Window.Swap (The_Window);
   end Frame_Handler;

   procedure Key_Handler (Event : in Lumen.Events.Event_Data) is
      use Lumen.Events;
      Key_Data : Key_Event_Data renames Event.Key_Data;
   begin
      if Key_Data.Key = To_Symbol (Ada.Characters.Latin_1.ESC) then
               -- Escape: quit
         End_Events (The_Window);
      end if;
   end Key_Handler;

begin
   Lumen.Window.Create
     (Win    => The_Window,
      Name   => "NeHe Lesson 5",
      Width  => 640,
      Height => 480,
      Events => (Lumen.Window.Want_Key_Press => True,
                 Lumen.Window.Want_Exposure  => True,
                 others                      => False));

   Resize_Scene (640, 480);
   Init_GL;

   Lumen.Events.Animate.Select_Events
     (Win   => The_Window,
      FPS   => Framerate,
      Frame => Frame_Handler'Unrestricted_Access,
      Calls =>
        (Lumen.Events.Resized      => Resize_Handler'Unrestricted_Access,
         Lumen.Events.Close_Window => Quit_Handler'Unrestricted_Access,
         Lumen.Events.Key_Press    => Key_Handler'Unrestricted_Access,
         others                    => Lumen.Events.No_Callback));

   Lumen.Window.Destroy_Context (The_Window);
   Lumen.Window.Destroy (The_Window);
end Lesson05;