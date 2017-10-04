//
//  GLObjLoader.h
//  GameSample
//
//  Created by Michael on 10/10/12.
//
//

#ifndef __GameSample__GLObjLoader__
#define __GameSample__GLObjLoader__

#include <iostream>
#include <vector>
#include "glm.hpp"

bool loadOBJ(
             const char * path,
             std::vector<glm::vec3> & out_vertices,
             std::vector<glm::vec2> & out_uvs,
             std::vector<glm::vec3> & out_normals
             );

#endif /* defined(__GameSample__GLObjLoader__) */
