from setuptools import find_packages, setup

setup(
    name="mlsolution",
    version="1.0.0",

    description="An MLOps continuous delivery solution with Terraform, CodePipeline, CodeBuild, and SageMaker Pipelines.",
    author="Joshua Goyder",
    email="jggoyder@amazon.com",
    packages=find_packages("src"), 
    package_dir={"": "src"},
    python_requires=">=3.9",
    classifiers=[
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT No Attribution License (MIT-0)',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Topic :: Software Development :: Code Generators',
        'Topic :: Utilities',
        'Typing :: Typed',
    ],
)
