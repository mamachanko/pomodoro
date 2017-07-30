package io.github.mamachanko.featuretests

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication


@SpringBootApplication
class FeatureTestsApplication

fun main(args: Array<String>) {
    SpringApplication.run(FeatureTestsApplication::class.java, *args)
}
