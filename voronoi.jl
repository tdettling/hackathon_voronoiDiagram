    # Extracting the adjacency matrix for a set of seeds
    # out of an approximate Voronoi Diagram
    #
    # An approximation to the Voronoi Diagram
    # This code creates a discrete approximation 
    # to the Voronoi Diagram
    using GraphRecipes
    using Plots
    using Base.Threads
    
    const SMALL_SIZE_AREA = 500
    const NSEEDS_D = rand(5:20)
    
    voronoi = zeros(Int32,SMALL_SIZE_AREA,SMALL_SIZE_AREA)
    seeds = Array{Int64}(undef, NSEEDS_D, 2)
    
    for seed in 1:NSEEDS_D
        seeds[seed,1] = rand(1:SMALL_SIZE_AREA)
        seeds[seed,2] = rand(1:SMALL_SIZE_AREA)
    end
    
    @threads for i in 1:SMALL_SIZE_AREA
        for j in 1:SMALL_SIZE_AREA
            shortestDistance = typemax(Int32)
            closestSeed = 0
            for k in 1:NSEEDS_D
                distance = (i - seeds[k,1])^2 + (j - seeds[k,2])^2
                distance = sqrt(distance)
                if distance < shortestDistance
                    shortestDistance = distance
                    closestSeed = k
                end
            end
            voronoi[i,j] = closestSeed
        end
    end
    
    # For every pixel, check if it has neighbor from a different
    # tile
    # Store the results in an adjacency matrix initialized to 0s
    adjacencyMatrix = zeros(Int32,NSEEDS_D,NSEEDS_D)
    for j in 2:SMALL_SIZE_AREA-1, i in 2:SMALL_SIZE_AREA-1
        # Check the four neighbors (it could be 8 neighbors)
        if voronoi[i,j] != voronoi[i-1,j]
            adjacencyMatrix[voronoi[i,j],voronoi[i-1,j]] = 1
            adjacencyMatrix[voronoi[i-1,j],voronoi[i,j]] = 1
        end
        if voronoi[i,j] != voronoi[i+1,j]
            adjacencyMatrix[voronoi[i,j],voronoi[i+1,j]] = 1
            adjacencyMatrix[voronoi[i+1,j],voronoi[i,j]] = 1
        end
        if voronoi[i,j] != voronoi[i,j-1]
            adjacencyMatrix[voronoi[i,j],voronoi[i,j-1]] = 1
            adjacencyMatrix[voronoi[i,j-1],voronoi[i,j]] = 1
        end
        if voronoi[i,j] != voronoi[i,j+1]
            adjacencyMatrix[voronoi[i,j],voronoi[i,j+1]] = 1
            adjacencyMatrix[voronoi[i,j+1],voronoi[i,j]] = 1
        end
    end
    
    # The first and last rows of the approximate Voronoi Diagram
    for j = 2:SMALL_SIZE_AREA 
        if voronoi[1,j-1] != voronoi[1,j] 
            adjacencyMatrix[voronoi[1,j],voronoi[1,j-1]] = 1
            adjacencyMatrix[voronoi[1,j-1],voronoi[1,j]] = 1
        end
        if voronoi[SMALL_SIZE_AREA,j-1] != voronoi[SMALL_SIZE_AREA,j]
            adjacencyMatrix[voronoi[SMALL_SIZE_AREA,j],voronoi[SMALL_SIZE_AREA,j-1]] = 1
            adjacencyMatrix[voronoi[SMALL_SIZE_AREA,j-1],voronoi[SMALL_SIZE_AREA,j]] = 1
        end
    end
    
    # The first and last columnas in the approximaate Voronoi Diagram
    for i = 2:SMALL_SIZE_AREA 
        if voronoi[i-1,1] != voronoi[i,1] 
            adjacencyMatrix[voronoi[i,1],voronoi[i-1,1]] = 1
            adjacencyMatrix[voronoi[i-1,1],voronoi[i,1]] = 1
        end
        if voronoi[i-1,SMALL_SIZE_AREA] != voronoi[i,SMALL_SIZE_AREA]
            adjacencyMatrix[voronoi[i-1,SMALL_SIZE_AREA],voronoi[i,SMALL_SIZE_AREA]] = 1
            adjacencyMatrix[voronoi[i,SMALL_SIZE_AREA],voronoi[i-1,SMALL_SIZE_AREA]] = 1
        end
    end
    
    println("Approximate Voronoi Diagram")
    println(voronoi)
    println("Adjacency Matrix")
    println(adjacencyMatrix)
    
    # Using the "seaborn" package to visualize the 
    # approximate voronoi Diagram
    #********************************************************#
    # Plots package
    gr()
    Plots.heatmap(voronoi)
    #********************************************************#
    # GraphRecipes Package
    graphplot(adjacencyMatrix,names=1:NSEEDS_D,fontsize = 10,
    linecolor = :darkgrey)
    #********************************************************#
    graphplot(adjacencyMatrix,names=1:NSEEDS_D,fontsize = 10,
    linecolor = :darkgrey)
