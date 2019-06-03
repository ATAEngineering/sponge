// Copyright (C) 2019, ATA Engineering, Inc.
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 3 of the License, or (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program; if not, write to the Free Software Foundation,
// Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.


#ifndef VECTOR_UTILS
#define VECTOR_UTILS

#include <Loci.h>
#include "mpi.h"
#include <iostream>

// function to gather vector and broadcast it to all processors
template <class T>
void AllGatherVector(std::vector<T> &p0v, const std::vector<T> &v,
                     const MPI_Comm &comm) {
  int rank = 0;
  MPI_Comm_rank(comm, &rank);
  int procs = 1;
  MPI_Comm_size(comm, &procs);

  // Gather sizes
  int local_size = v.size();
  std::vector<int> recv_sizes(procs);
  MPI_Allgather(&local_size, 1, MPI_INT, &recv_sizes[0], 1, MPI_INT, comm);

  // Allocate receive array
  int tot_size = recv_sizes[0];
  for (int i = 1; i < procs; ++i) {
    tot_size += recv_sizes[i];
  }
  if (tot_size != int(p0v.size())) {
    p0v.resize(tot_size);
  }

  // Compute sizes in bytes
  const int bsz = sizeof(T);
  for (int i = 0; i < procs; ++i) {
    recv_sizes[i] *= bsz;
  }

  // Bookkeeping for gatherv call
  std::vector<int> displs(procs);
  displs[0] = 0;
  for (int i = 1; i < procs; ++i) {
    displs[i] = displs[i - 1] + recv_sizes[i - 1];
  }

  // Gather data
  MPI_Allgatherv(&v[0], local_size * bsz, MPI_BYTE, &p0v[0], &recv_sizes[0],
                 &displs[0], MPI_BYTE, comm);
}

#endif
