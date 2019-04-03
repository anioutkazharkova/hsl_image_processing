import UIKit
import PlaygroundSupport
import CoreImage

class Filter: CIFilter {
    
    let kernel: CIColorKernel? = {
        let kernelString =
            "kernel vec4 RGB_to_GBR(__sample pixel)\n" +
                "{\n" +
                "vec4 twistedColor = pixel.gbra;\n" +
                
                "return twistedColor;\n" +
        "}\n"
        
        return CIColorKernel(source: kernelString)
    }()
    
    
    @objc dynamic   var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        guard let kernel = kernel, let inputImage = inputImage else {
            return nil
        }
        
        return kernel.apply(extent: inputImage.extent,
                            arguments: [inputImage])
    }
}



var str = "Hello, playground"
let  im = UIImage(named:"image.jpg")

var filter = Filter()
filter.inputImage = im?.ciImage

var output = filter.outputImage

        if let outp = output {
        var image = UIImage(ciImage: outp)
        }


