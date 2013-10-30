with
     openGL.Buffer.general,
     openGL.Shader,
     openGL.Program.lit_textured,
     openGL.Attribute,
     opengl.Texture,
     openGL.Palette,

     GL.lean,
     GL.Pointers,

     System,
     interfaces.c.Strings,
     system.Storage_Elements;


package body opengl.Geometry.lit_textured
is
   use GL.lean,
       GL.Pointers,
       Interfaces;


   --  Globals
   --

   the_vertex_Shader    : aliased openGL.Shader.item;
   the_fragment_Shader  : aliased openGL.Shader.item;
   the_Program          :         openGL.Program.lit_textured.view;
   white_Texture        :         openGL.Texture.Object;

   Attribute_1_Name     : aliased          C.char_array        := "aSite";
   Attribute_1_Name_ptr : aliased constant C.strings.chars_ptr := C.strings.to_chars_ptr (Attribute_1_Name'Access);

   Attribute_2_Name     : aliased          C.char_array        := "aNormal";
   Attribute_2_Name_ptr : aliased constant C.strings.chars_ptr := C.strings.to_chars_ptr (Attribute_2_Name'Access);

   Attribute_3_Name     : aliased          C.char_array        := "aCoords";
   Attribute_3_Name_ptr : aliased constant C.strings.chars_ptr := C.strings.to_chars_ptr (Attribute_3_Name'Access);



   --  Forge
   --

   type Geometry_view is access all Geometry.lit_textured.item'class;


   function new_Geometry return access Geometry.lit_textured.item'class
   is
      use      System,
               system.Storage_Elements;
      use type openGL.Program.lit_textured.view;

      Self : constant Geometry_view := new Geometry.lit_textured.item;
   begin
      if the_Program = null then   -- Define the shaders and program.
         declare
            use openGL.Palette;

            sample_Vertex : Vertex;

            Attribute_1   : openGL.Attribute.view;
            Attribute_2   : openGL.Attribute.view;
            Attribute_3   : openGL.Attribute.view;

            white_Image   : constant openGL.Image := (1 .. 2 => (1 .. 2 => White));
         begin
            white_Texture := openGL.Texture.to_Texture (white_Image);

            the_vertex_Shader  .define (openGL.Shader.Vertex,   "assets/mmi/shader/lit_textured.vert");
            the_fragment_Shader.define (openGL.Shader.Fragment, "assets/mmi/shader/lit_textured.frag");

            the_Program := new openGL.Program.lit_textured.item;
            the_Program.define (the_vertex_Shader  'Access,
                                the_fragment_Shader'Access);
            the_Program.enable;

            Attribute_1 := attribute.Forge.new_Attribute (name        => "aSite",
                                                          gl_location => the_Program.attribute_Location ("aSite"),
                                                          size        => 3,
                                                          data_kind   => attribute.GL_FLOAT,
                                                          stride      => lit_textured.Vertex'Size / 8,
                                                          offset      => 0,
                                                          normalized  => False);

            Attribute_2 := attribute.Forge.new_Attribute (name        => "aNormal",
                                                          gl_location => the_Program.attribute_Location ("aNormal"),
                                                          size        => 3,
                                                          data_kind   => attribute.GL_FLOAT,
                                                          stride      => lit_textured.Vertex'Size / 8,
                                                          offset      =>   sample_Vertex.Normal (1)'Address
                                                                         - sample_Vertex.Site   (1)'Address,
                                                          normalized  => False);

            Attribute_3 := attribute.Forge.new_Attribute (name        => "aCoords",
                                                          gl_location => the_Program.attribute_Location ("aCoords"),
                                                          size        => 2,
                                                          data_kind   => attribute.GL_FLOAT,
                                                          stride      => lit_textured.Vertex'Size / 8,
                                                          offset      =>   sample_Vertex.Coords.S'Address
                                                                         - sample_Vertex.Site (1)'Address,
                                                          normalized  => False);
            the_Program.add (Attribute_1);
            the_Program.add (Attribute_2);
            the_Program.add (Attribute_3);

            glBindAttribLocation (program =>  the_Program.gl_Program,
                                  index   =>  the_Program.Attribute (named => "aSite").gl_Location,
                                  name    => +Attribute_1_Name_ptr);

            glBindAttribLocation (program =>  the_Program.gl_Program,
                                  index   =>  the_Program.Attribute (named => "aNormal").gl_Location,
                                  name    => +Attribute_2_Name_ptr);

            glBindAttribLocation (program =>  the_Program.gl_Program,
                                  index   =>  the_Program.Attribute (named => "aCoords").gl_Location,
                                  name    => +Attribute_3_Name_ptr);
         end;
      end if;

      Self.Program_is (the_Program.all'Access);
      return Self;
   end new_Geometry;



   --  Attributes
   --

   overriding
   function is_Transparent (Self : in Item) return Boolean
   is
   begin
      return Self.is_Transparent;
   end is_Transparent;



   function is_Transparent (Self : access Vertex_array) return Boolean
   is
      pragma Unreferenced (Self);
      use type color_Value;
   begin
      --  tbd: also need to check if texture is transparent ?
      return False;
   end is_Transparent;



   --  Operations
   --

   package opengl_Buffer_of_geometry_Vertices is new opengl.Buffer.general (base_object   => opengl.Buffer.array_Object,
                                                                            index         => Index_t,
                                                                            element       => Vertex,
                                                                            element_array => Vertex_array);

   procedure Vertices_are (Self : in out Item'Class;   Now : access Vertex_array)
   is
      use      opengl_Buffer_of_geometry_Vertices;
      use type Index_t;
   begin
      Self.Vertices := new opengl_Buffer_of_geometry_Vertices.Object' (to_Buffer (Now,
                                                                                  usage => opengl.buffer.static_Draw));
      Self.is_Transparent := is_Transparent (Now);
   end Vertices_are;



   overriding
   procedure Indices_are  (Self : in out Item;   Now       : in Indices;
                                                 for_Facia : in Positive)
   is
   begin
      raise Program_Error with "TBD";
   end Indices_are;



   overriding
   procedure enable_Texture (Self : in Item)
   is
      use GL,
          openGL.Texture;
   begin
      glActiveTexture (gl.GL_TEXTURE0);

      if Self.Texture = openGL.Texture.null_Object then
         enable (white_Texture);
      else
         enable (Self.Texture);
      end if;
   end enable_Texture;


end opengl.Geometry.lit_textured;