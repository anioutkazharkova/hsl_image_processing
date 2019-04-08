import Foundation
import UIKit
import  CoreImage

/*class   Filter: CIFilter {
    
    @objc var inputImage: CIImage?
    
    private let kernel = CIKernel(source: """
kernel vec4 anaglyphRedCyan(sampler leftSamp, sampler rightSamp){
    //получаем пиксель левого изображения
vec4 l = sample(leftSamp,samplerCoord(leftSamp));
    //убираем зеленый и синий каналы
    l.g = l.b = 0.0;
    //получаем пиксель правого изображения
    vec4 r = sample(rightSamp,samplerCoord(rightSamp));
    //убираем красный канал
    r.r = 0.0;
    //накладываем изображением методом "Экран"
    vec4 ret;
    //красный канал
    ret.r = 1.0 - (1.0 - l.r)*(1.0 - r.r);
    //зеленый канал
    ret.g = 1.0 - (1.0 - l.g)*(1.0 - r.g);
    //синий канал
    ret.b = 1.0 - (1.0 - l.b)*(1.0 - r.b);
    //прозрачность не используется
    ret.a = 1.0;
    //результат
    return ret;
    }
""")
    
    override var outputImage: CIImage? {
        guard let kernel = kernel, let inputImage = inputImage else {return nil}
        return kernel.applyWithExtent(inputImage.extent, arguments:[inputImage])
    }
    
}
*/

class RGB_to_GBR: CIFilter {

    let kernel: CIColorKernel = {
        let kernelString =
            "kernel vec4 RGB_to_GBR(__sample pixel)\n" +
                "{\n" +
                "vec4 twistedColor = pixel.gbra;\n" +

                "return twistedColor;\n" +
        "}\n"

        return CIColorKernel(source: kernelString)!
    }()

    var inputImage: CIImage?

    override var outputImage: CIImage? {
        guard let inputImage = inputImage else {
            return nil
        }

        return kernel.apply(extent: inputImage.extent,
                            arguments: [inputImage])
    }
}

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
