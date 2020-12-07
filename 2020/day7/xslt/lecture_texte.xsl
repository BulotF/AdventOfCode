<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

    <xsl:param name="text-file"/>

    <xsl:template match="/">
        <!-- On crée une variable qui prend en entrée l'adresse du fichier et en contient le contenu textuel -->
        <xsl:variable name="text-content" select="unparsed-text($text-file)"/>
        <Bags>
            <!-- On découpage la chaîne textuelle selon le caractère de passage à la ligne -->
            <xsl:for-each select="tokenize($text-content,'&#xD;&#xA;')">
                <Bag>
                    <xsl:attribute name="color" select="substring-before(.,' bags contain')"/>
                    <xsl:if test="substring-after(.,' bags contain ') != 'no other bags.'">
                        <xsl:for-each select="tokenize(substring-after(.,' bags contain '),', ')">
                            <Bag>
                                <xsl:attribute name="color" select="substring-after(substring-before(.,' bag'),' ')"/>
                                <xsl:attribute name="quantity" select="substring-before(.,' ')"/>
                            </Bag>
                        </xsl:for-each>
                    </xsl:if>
                </Bag>
            </xsl:for-each>
        </Bags>
    </xsl:template>

</xsl:stylesheet>